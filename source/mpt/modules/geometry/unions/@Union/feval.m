function y = feval(U,x,fnames)
%
% evaluated a given function if associated to an union
%

% global options
global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

error(nargchk(2,3,nargin));

if nargin<3
    fnames={};
end

if numel(U)>1
    y = cell(size(U));
    parfor i=1:numel(U);
        y{i} = feval(U(i),x,fnames);
    end
    return
elseif U.Num==0
    y = [];
    return
end

% extract function names
if ~iscell(fnames)
	fnames = {fnames};
end
if isempty(fnames)
    fnames=U.listFunctions;
end
if any(~U.hasFunction(fnames))
    error('The provided union does not have required functions associated to a set.');
end

validate_realvector(x);
USet = U.Set;
polyhedra = ~iscell(USet);

for i=1:U.Num
	if (polyhedra && USet(i).Dim~=length(x)) || ...
			(~polyhedra && USet{i}.Dim~=length(x))
        error('All sets must be in the same dimension %d as the provided vector.',length(x));
    end
end

y = cell(numel(fnames),1);
for j=1:numel(fnames)
    % get the index of the set in which the point lies
    [isin, inwhich] = U.contains(x);
    if ~isin
        % the point is outside
        if MPTOPTIONS.verbose>=1
            fprintf('Given point is outside of the domain for function %i.\n',j)
        end
        y{j} = [];
    else
        % evaluate
        if numel(inwhich)==1
			if polyhedra
				y{j} = feval(U.Set(inwhich),x,fnames{j});
			else
				y{j} = feval(U.Set{inwhich},x,fnames{j});
			end
        else
            y{j} = cell(size(inwhich));
            for k=1:numel(inwhich)
				if polyhedra
					y{j}{k} = feval(U.Set(inwhich(k)),x,fnames{j});
				else
					y{j}{k} = feval(U.Set{inwhich(k)},x,fnames{j});
				end
            end
        end
    end

end

if numel(y)==1
    y = y{1};
end

end
