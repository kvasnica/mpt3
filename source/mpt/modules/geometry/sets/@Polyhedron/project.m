function sol = project(obj, y)
% <matDoc>
% <funcName>Project</funcName>
% <shortDesc>Compute the projection of the point y onto this polyhedron.<longDesc/>
%
% <syntax>
% <desc>Compute the projection of the point y onto this polyhedron.
%
% Solve the optimization problem:
%
%   J(y) = min ||y-x||_2 s.t. x in Set
%
% and return an optimizer x.
%
% </desc>
% <input name='x'>Vector of length dim(d)</input>
% <output name='sol'>Structure with fields
%   x       - Projected point or [] if emptyset
%   flag    - mptopt return type
%   flagTxt - mptopt return type text
%   dist    - Distance from x to the set, or [] if emptyset
% </output>
% </syntax>
%
% </matDoc>

global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

% check dimension
D = [obj.Dim];
if any(D(1)~=D)
    error('The polyhedron array must be in the same dimension.');
end

% deal with arrays
error(obj.rejectArray());

dim = obj.Dim;
if dim<1
    error('Cannot project with empty polyhedra.');
end
validate_realmatrix(y);

% y is either a list of row vectors, or a single row or column vectors
if size(y,1) == 1 || size(y,2) == 1,
    y = y(:)';
end
if size(y,2) ~= dim,
    error('Single point "x" must be given a vector of length %i and multiple points as a matrix of size n x %i\n', dim, dim);
end

%% Project points onto the polyhedra
sol(1,size(y,1)) = struct('x',[],'exitflag',[],'dist',[]); 

for j = 1:size(y,1)
    
    % (x-y)'(x-y) = x'x - 2*x'y + y'y
    qp   = obj.optMat;
 
    % semidefinite QP
    cost = obj.buildCost(-2*y(j,:)', 2*eye(obj.Dim));
    qp.f = cost.f; qp.H = cost.H;    
	qp.quickqp = true;
    opt  = mpt_solve(qp);
    
    % if not feasible, retry with setting bounds on all variables - helps
    % to recover feasibility 
    if opt.exitflag ~= MPTOPTIONS.OK
       qp.lb(qp.lb<-MPTOPTIONS.infbound) =-MPTOPTIONS.infbound;
       qp.ub(qp.ub>MPTOPTIONS.infbound) = MPTOPTIONS.infbound;
       opt  = mpt_solve(qp);
    end
    
    sol(1,j).exitflag    = opt.exitflag;
    sol(1,j).dist    = [];
    if sol(1,j).exitflag == MPTOPTIONS.OK,
        sol(1,j).x       = opt.xopt(1:obj.Dim);
        sol(1,j).dist = norm(sol(1,j).x - y(j,:)');
    end
end



end

