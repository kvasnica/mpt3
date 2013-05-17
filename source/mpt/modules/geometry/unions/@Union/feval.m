function [fval, feasible, idx, tie_value] = feval(obj, x, varargin)
%
% evaluates a given function
%

error(nargchk(2, Inf, nargin));
% use obj.forEach(@(z) z.feval(x, ...)) to evaluate arrays of unions
error(obj.rejectArray());

fval = [];
feasible = false;
idx = [];
tie_value = [];
if numel(obj)==0 || numel(obj.Set)==0
	return
end

%% parse inputs
function_name = '';
options.tiebreak = []; % no tie-breaking by default
options.regions = [];
if nargin>2
	if mod(nargin, 2)==0
		% U.feval(x, ['option', value, ...])
		start_idx = 1;
	else
		% U.feval(x, 'function', ['option', value, ...])
		function_name = varargin{1};
		start_idx = 2;
	end
	for i = start_idx:2:length(varargin)
		options.(varargin{i}) = varargin{i+1};
	end
end
	
%% validate arguments
validate_realvector(x);
if isempty(function_name)
	fnames = obj.listFunctions();
	if isempty(fnames)
		error('The object has no functions.');
	elseif length(fnames)>1
		error('The object has multiple functions, specify the one to evaluate.');
	else
		function_name = fnames{1};
	end
elseif ~ischar(function_name)
	error('The function name must be a string.');
elseif ~obj.hasFunction(function_name)
	error('No such function "%s" in the object.', function_name);
end
if ~(isempty(options.tiebreak) || isa(options.tiebreak, 'char') || ...
		isa(options.tiebreak, 'function_handle'))
	error('The tiebreak option must be a string or a function handle.');
end
if ~isnumeric(options.regions)
	error('The regions option must be a vector of integers.');
end
if (ischar(options.tiebreak) && ~obj.hasFunction(options.tiebreak))
	error('No such function "%s" in the object.', options.tiebreak);
end


%% evaluate
iscell_set = iscell(obj.Set);

	function out = eval_region(ridx, fun)
		% applies either {i} or (i) indexing of the set, evaluates function
		% 'fun' at 'x'
		%
		% since this is an inline function, "obj" and "x" are taken from
		% the main function's workspace
		if iscell_set
			out = obj.Set{ridx}.Functions(fun).Handle(x);
		else
			out = obj.Set(ridx).Functions(fun).Handle(x);
		end
	end

% size of the output
m = size(eval_region(1, function_name), 1);

% which regions contain "x"?
if isempty(options.regions)
	[feasible, idx] = obj.contains(x);
else
	feasible = true;
	idx = options.regions;
end
if feasible
	% x in regions indexed by idx
	n = numel(idx);
	fval = zeros(m, n);
	if n>1 && ~isempty(options.tiebreak) && isempty(options.regions)
		% tie-breaking (not applied if regions are provided)
		if ischar(options.tiebreak)
			% assumes "tiebreak" is a function of the union
			tb_fun = @(i, z) eval_region(i, options.tiebreak);
		else
			% tiebreak is a function handle
			tb_fun = @(i, z) options.tiebreak(z);
		end
		tval = zeros(1, n);
		for i = 1:n
			% evaluate the tie-break function in each region
			tb_val = tb_fun(idx(i), x);
			if ~isscalar(tb_val)
				error('The tie breaker must be a scalar-valued function.');
			end
			tval(i) = tb_val;
		end
		% pick the region in which the tiebreak has minimal value
		[tie_value, tie_region] = min(tval);
		idx = idx(tie_region);
		% return single function value if we have tiebreak rules
		fval = eval_region(idx, function_name);
	else
		% no tie-breaking, just evaluate the function in all regions which
		% contain "x"
		for i = 1:n
			fval(:, i) = eval_region(idx(i), function_name);
		end
	end
else
	% not in the domain
	fval = NaN(m, 1);
end

end
