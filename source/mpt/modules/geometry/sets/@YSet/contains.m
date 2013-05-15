function ts = contains(obj,x)
%
% test if the point is contained in this set by assigning 
% equality constraints and evaluation of primal residuals
%

global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

error(nargchk(2,2,nargin));

% check vector x
validate_realvector(x);

% deal with arrays
no = numel(obj);
if no>1
    ts = false(size(obj));
    for i=1:no
        ts(i) = obj(i).contains(x);
    end
    return
end


% check dimension
if numel(x)~=obj.Dim
    error('The point must be a vector with dimension %i.', obj.Dim);
end
if any(size(x)~=size(obj.vars))
    x = transpose(x);
end

% assign value
assign(obj.vars, x);

% check residual
residual = checkset(obj.constraints);

% if all residuals are nonnegative, the solution is feasible
if all(residual>-MPTOPTIONS.abs_tol)
    ts = true;
else
    ts = false;
end

end