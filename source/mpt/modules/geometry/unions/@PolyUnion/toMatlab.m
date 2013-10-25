function toMatlab(obj, filename, function_to_export, tiebreak)
% Generates pure matlab code for evaluation of a particular function
%
% Syntax:
% ---
%
%   obj.toMatlab(filename, function_to_export, tiebreak_function)
%
% Inputs:
% ---
%
%  obj: single PolyUnion or an array thereof
%  filename: name of exported file (the '.m' extension will be added)
%  function_to_export: string indicating which function should be exported
%  tiebreak: name of function to use to resolve tiebreaks
%            (set it to 'first-region' to break the sequential search once
%            the first region containing a given point is found)
%
% Output:
% ---
%
%  File "filename.m" that can be called as follows:
%
%    [zopt, region, union] = filename(x)
%
%  where "x" is the vector of parameters at which function_to_export is to
%  be evaluated, "zopt" is the value of the function at "x", "region" is
%  the index of a region that contains "x", and "union" is the index of the
%  partition that contains the region which contains "x".

global MPTOPTIONS

%% parsing
error(nargchk(4, 4, nargin));

%% validation
if ~all(obj.hasFunction(function_to_export))
	error('No such function "%s" in the object.', function_to_export);
elseif isempty(tiebreak)
	error('The tiebreak function must be specified.');
elseif ~isequal(tiebreak, 'first-region') && ...
		~all(obj.hasFunction(tiebreak))
	error('No such function "%s" in the object.', tiebreak);
elseif any(diff([obj.Dim])~=0)
	error('All unions must be in the same dimension.');
end

%% export

% write function header
[f_path, f_name, f_ext] = fileparts(filename);
if isempty(f_path)
	full_path = [f_name '.m'];
else
	full_path = [f_path filesep f_name '.m'];
end
fid = fopen(full_path, 'w');
fprintf(fid, 'function [z, ir, ip] = %s(x)\n', f_name);
fprintf(fid, 'if numel(x)~=%d, error(''The input vector must have %d elements.''); end\n', ...
	obj(1).Dim, obj(1).Dim);
% H-representation is checked by H*[x; -1]<=0, He*[x; -1]==0
fprintf(fid, 'x=x(:);xh=[x;-1];\n');
	
% write regions and functions for each element of the array
for i = 1:numel(obj)
	% for each element of the array of unions we prepare the following
	% structure:
	%   .nr: number of regions
	%   .nz: range of the exported function
	%   .nx: dimension of the object (=number of parameters)
	%    .H: inequality representation of regions
	%   .He: equality representation
	%   .ni: number of inequality constraints in each region
	%   .ne: number of equality constraints in each region
	%   .fH,.fF,.fg: quadratic (or affine) representation of the function
	%                to be exported, i.e., z = x'*fH*x + fF*x + fg
	%   .tH,.tF,.tg: representation of the tiebreak function (empty if the
	%                first-region tiebreak is to be used)
	
	% extract H-representation of each region
	H = obj(i).Set.forEach(@(x) x.H, 'UniformOutput', false);
	He = obj(i).Set.forEach(@(x) x.He, 'UniformOutput', false);
	% number of inequality/equality constraints for each region
	ni = obj(i).Set.forEach(@(x) size(x.H, 1), 'UniformOutput', false);
	ne = obj(i).Set.forEach(@(x) size(x.He, 1), 'UniformOutput', false);

	% concatenate cells into one large matrix
	Hm = cat(1, H{:});
	if isempty(Hm)
		% save some space if we have no inequality constraints
		nim = [];
		Hm = [];
	else
		nim = cumsum([1;cat(1, ni{:})]);
	end
	Hem = cat(1, He{:});
	if isempty(Hem)
		% save some space if we have no equality constraints
		nem = [];
		Hem = [];
	else
		nem = cumsum([1;cat(1, ne{:})]);
	end

	% extract parameters of the functions
	[fnz, fH, fF, fg] = get_function_data(obj(i), function_to_export);
	if any(diff(fnz)~=0)
		error('In all regions the function "%s" must have range %d.', ...
			function_to_export, fnz(1));
	end
	if ~isequal(tiebreak, 'first-region')
		[tnz, tH, tF, tg] = get_function_data(obj(i), tiebreak);
		if any(tnz~=1)
			error('The tie breaker must be a scalar-valued function.');
		end
	else
		tH = [];
		tF = [];
		tg = [];
	end
	
	% write the data
	fprintf(fid, 'r(%d) = struct(''nr'',%d,''H'',%s,''He'',%s,''ni'',%s,''ne'',%s,''fH'',%s,''fF'',%s,''fg'',%s,''tH'',%s,''tF'',%s,''tg'',%s,''nz'',%d,''nx'',%d);\n', ...
		i, obj(i).Num, mat2str(Hm), mat2str(Hem), mat2str(nim), ...
		mat2str(nem), mat2str(fH), mat2str(fF), mat2str(fg), ...
		mat2str(tH), mat2str(tF), mat2str(tg), fnz(1), obj(i).Dim);
end

% export code

% loop through each partition and through
fprintf(fid, 'tb=[];\n');
fprintf(fid, 'for ip=1:numel(r),reg=r(ip);\n');

% loop through each region of the partition
fprintf(fid, 'H=reg.H;He=reg.He;ni=reg.ni;ne=reg.ne;nx=reg.nx;nz=reg.nz;\n');
fprintf(fid, 'eH=isempty(H);eHe=isempty(He);\n');
fprintf(fid, 'for ir=1:reg.nr\n');

% is "x" contained in the region?
fprintf(fid, 'Hx=eH||all(H(ni(ir):ni(ir+1)-1,:)*xh<=%.g);\n', MPTOPTIONS.zero_tol);
fprintf(fid, 'Hex=eHe||all(abs(He(ne(ir):ne(ir+1)-1,:)*xh)<=%g);\n', MPTOPTIONS.zero_tol);
fprintf(fid, 'if Hx&&Hex\n');
if isequal(tiebreak, 'first-region')
	% if so, return the optimizer
	fprintf(fid, 'z=reg.fF((ir-1)*nz+1:ir*nz,:)*x+reg.fg((ir-1)*nz+1:ir*nz);\n');
	fprintf(fid, 'if ~isempty(reg.fH),z=z+x''*reg.fH((ir-1)*nx+1:ir*nx,:)*x;end;\n');
	fprintf(fid, 'return\n');
else
	% more difficult case: record value of the tiebreak function
	fprintf(fid, 'tv=reg.tF(ir,:)*x+reg.tg(ir);\n');
	fprintf(fid, 'if ~isempty(reg.tH),tv=tv+x''*reg.tH((ir-1)*nx+1:ir*nx,:)*x;end\n');
	fprintf(fid, 'tb=[tb;ip,ir,tv];\n');
end	

fprintf(fid, 'end\n');% end if Hx && Hex
fprintf(fid, 'end;\n'); % end ir
fprintf(fid, 'end;\n'); % end ip

% in which partition/region is the tiebreak value minimal?
fprintf(fid, 'if ~isempty(tb)\n');
fprintf(fid, '[~,j]=min(tb(:,end));\n');
fprintf(fid, 'ip=tb(j,1);ir=tb(j,2);\n');
% evaluate the function in this region
fprintf(fid, 'z=r(ip).fF((ir-1)*r(ip).nz+1:ir*r(ip).nz,:)*x+r(ip).fg((ir-1)*r(ip).nz+1:ir*r(ip).nz);\n');
fprintf(fid, 'if ~isempty(r(ip).fH),z=z+x''*r(ip).fH((ir-1)*r(ip).nx+1:ir*r(ip).nx,:)*x;end;\n');
fprintf(fid, 'return\n');
fprintf(fid, 'end\n');

% return indication of infeasibility
fprintf(fid, 'ip=0;ir=0;z=NaN;\n');

% footer
fprintf(fid, 'end\n');

fclose(fid);

fprintf('Function "%s" with tiebreak "%s" exported to "%s".\n', ...
	function_to_export, tiebreak, full_path);

end

function [nz, Hfm, Fm, gm] = get_function_data(obj, funname)

fun = obj.Set(1).Functions(funname);
if ~(isa(fun, 'AffFunction') || isa(fun, 'QuadFunction'))
	error('Only affine and quadratic functions can be exported.');
end

% range of the function in each region
nz = obj.Set.forEach(@(x) x.Functions(funname).R);
F = obj.Set.forEach(@(x) x.Functions(funname).F, 'UniformOutput', false);
g = obj.Set.forEach(@(x) x.Functions(funname).g, 'UniformOutput', false);
Fm = cat(1, F{:});
gm = cat(1, g{:});
if isa(fun, 'QuadFunction')
	Hf = obj.Set.forEach(@(x) x.Functions(funname).H, 'UniformOutput', false);
	Hfm = cat(1, Hf{:});
else
	Hfm = [];
end

end
