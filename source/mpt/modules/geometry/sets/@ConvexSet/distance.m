function ret = distance(obj, x)
% DISTANCE Compute the distance between the given point and this set.
%
% ret = distance(x)
%
% Solves the optimization problem:
%
%   min ||x-y||_2 s.t. y in Set
%
% Parameters:
%  x - Vector of length dim
%
% Returns:
%  dist - Distance between x and this set or [] is emptyset
%     x - the point x
%     y - the point inside this Set that is the closest to x
%

error(nargchk(2,2,nargin));

% if obj is an array, put the results inside an array
if numel(obj)>1
    ret = cell(size(obj));
    for i=1:numel(obj)
        ret{i} = obj(i).distance(x);
    end
    return;
end

validate_realvector(x);

if length(x)~=obj.Dim
    error('The vector must have a length of %i', obj.Dim);
end

sol = obj.project(x);
ret.exitflag = sol.exitflag;
ret.dist = sol.dist;
ret.x = x;
ret.y = sol.x;
end
