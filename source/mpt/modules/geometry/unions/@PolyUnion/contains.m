function [isin, inwhich, closest] = contains(U,x,fastbreak)
%
% test if the point x belongs to any of the sets stored under the PolyUnion
%

if nargin<3
    fastbreak = false;
else
    if isnumeric(fastbreak) || islogical(fastbreak)
        fastbreak = logical(fastbreak);
    else
        error('The "fastbreak" option must have numerical or logical value.');
    end
    if ~isscalar(fastbreak)
        error('The "fastbreak" must be scalar.')
    end
end

% deal with arrays
if numel(U)>1
    isin = false(size(U));
    inwhich = cell(size(U));
    closest = cell(size(U));
    parfor i=1:numel(U)
        [isin(i),inwhich{i},closest{i}] = U(i).contains(x, fastbreak);
    end
    return;
end

if U.Num==0
    % for empty array return empty
    isin = false;
    inwhich = [];
    closest = [];
    return
end

validate_realvector(x);

if numel(x)~=U.Dim
    error('The dimension of the input vector must be %d.',U.Dim);
end

% recursive search
isin = false;
inwhich = [];
closest = [];

if all([U.Set.hasHRep])
    % prefer mex-function if all polyhedra are in H-rep
    [isin,inwhich] = U.Set.isInside(x,struct('fastbreak',fastbreak));
else    
    for i=1:U.Num
        if U.Set(i).contains(x)
            isin = true;
            inwhich = [inwhich; i];
            if fastbreak
                return;
            end
        end
    end
end

if ~isin && nargout>2
    d = Inf(1,U.Num);
    parfor i=1:U.Num
        s = distance(U.Set(i),x);
        if ~isempty(s.dist)
            d(i) = s.dist;
        end
    end
    [dmin, closest] = min(d);
end


end
