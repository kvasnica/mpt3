function supp = support(obj, x)
%
%
% SUPPORT Compute the support of this set in the direction x.
%
% supp = support(x)
%
% Solves the optimization problem:
%
%   support(x) := max x'*y s.t. y in Set
%
% Paramaters:
%  x  - Vector of length dim
%
% Returns
%  supp - support of x or [] if empty
%


error(nargchk(2,2,nargin));

% x can be an array of points put in a matrix
validate_realmatrix(x);

% deal with arrays
no = numel(obj);
if no>1
    supp = Inf*ones(size(obj));
    for i=1:no
        supp(i) = obj(i).support(x);        
    end
    return
end
    
if size(x,1) == 1 || size(x,2) == 1
    x = x(:)';
    if numel(x)~=obj.Dim,
        error('Input argument "x" must be a vector of length %i.', obj.Dim);
    end
else
    if size(x,2) ~= obj.Dim,
        error('Input argument "x" must be a matrix of size n x %i.', obj.Dim);
    end
end

supp = Inf*ones(size(x,1),1);
for i=1:size(x,1)
    sol  = obj.extreme(x(i,:)');
    if ~isempty(sol.supp)
        supp(i) = sol.supp;
    end
end
end
