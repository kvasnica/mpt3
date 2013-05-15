function y = feval(P,x,name)
%
% evaluated a given function if associated to a polyhedron
%

% global options
global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

error(nargchk(2,3,nargin));

if nargin<3
    name=[];
end

if numel(P)>1
    y = cell(size(P));
    parfor i=1:numel(P);
        y{i} = feval(P(i),x,name);
    end
    return
end

if isempty(name)
	name = P.listFunctions;
end
if ~iscell(name)
	name = {name};
end

validate_realvector(x);
y = cell(length(name), 1);
for j = 1:length(name)
	Fj = P.getFunction(name{j});
	if ~isEmptyFunction(Fj)
		if P.Dim~=length(x)
			error('Given vector must have the dimension %d, the same as the set.',P.Dim);
		end
		if ~P.contains(x)
			if MPTOPTIONS.verbose>=1
				fprintf('Given point is outside of the domain for function %i.\n',j)
			end
			y{j} = [];
		else
			y{j} = feval(Fj.Handle,x);
		end
	end
end

if numel(y)==1
    y = y{1};
end

end
