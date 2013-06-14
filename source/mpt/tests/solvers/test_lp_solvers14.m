function test_lp_solvers14(solver, tol)
% inequality matrix A constains a lot of linearly dependent rows

fname = mfilename;
check_LPsolvers;

% simple lower and upper bounds
S.lb = -10*ones(4,1);
S.ub = 8*ones(4,1);

% random inequality matrix
A = [-0.4 0 0 0.9; -3 -0.5 0.6 12000;1 2 0 0 ;1 2 0 0];
S.A = [A; -A; 2*A(1,:); -0.6*A(2,:)];
S.b = [1:10]';

% cost function
S.f = [-5;1;0;0];

% assign solver
S.solver = solver;

% call mpt_solve
R = mpt_solve(S);

% multiple solutions exist, we compare only objective function
xd = [ 8;-7.5; 8; 0.0014542];
fd = -47.5;

% compare results
if norm(fd-R.obj,Inf)>tol
    error('Objective functions do not match.');
end

%mbg_asserttolequal(R.xopt,p.xopt,tol);
%mbg_asserttolequal(R.obj,p.fopt,tol);

end