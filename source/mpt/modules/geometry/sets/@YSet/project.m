function sol = project(obj, x)
%
% Compute the projection of the point x onto this set.
% Computes the closest point in this set to the point x:
%
% Parameters:
% x - Vector of length d
%
% Returns (as elements of ret)
% p    - Closest point to x contained in this set, or NULL if empty.
% flag -  1  if infeasible
%         2  if unbounded
%         12 if infeasible or unbounded (can't tell which)
%         0  if ok
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
    sol = cell(size(obj));
    for i=1:no
        sol{i} = obj(i).project(x);        
    end
    return
end

% check dimension
if numel(x)~=obj.Dim
    error('The argument must have %i number of elements.', obj.Dim);
end

if any(size(x)~=size(obj.vars))
    x = transpose(x);
end

% if x was created out of the matrix, there might be symmetric terms, 
% the assign command checks for the compatibility of the vector
assign(obj.vars, x);

% solve the problem via YALMIP
cost = norm(x - obj.vars,2)^2;
d = solvesdp(obj.constraints, cost, obj.opts);

% if we don't know if it is feasible or unbounded, retry with artificial bounds
if ismember(d.problem,[12, 15])
    F = obj.contraints + set( -MPTOPTIONS.infbound*ones(size(obj.vars)) <= obj.vars <= MPTOPTIONS.infbound*ones(size(obj.vars)) );
    d = solvesdp(F, cost, obj.opts);
    % if solution is feasible -> unbounded
    if d.problem == 0
        d.problem = 2;
    else
        % infeasible
        d.problem = 1;
    end
end

% get MPT flags
sol = yalmip2mptflag(d);

switch sol.exitflag
    case MPTOPTIONS.OK,
        sol.x = double(obj.vars);
        sol.dist = sqrt(double(cost));
    case MPTOPTIONS.INFEASIBLE,
        sol.x = [];
        sol.dist = NaN;
    case MPTOPTIONS.UNBOUNDED,
        sol.x = [];
        sol.dist = Inf;
    otherwise
        error('Solver returned "%s" error when called from YALMIP.',sol.how);
end
end
