function test_lp_solvers11(solver, tol)
% test overdetermined, but feasible system
 n = 40; % variables
 m = 120; % inequality constraints
 me = 42; % equality constraints

% random system An*x=bn
An = randn(n,n);
bn = rand(n,1);
xopt = An\bn;

% two more rows are row-dependent
S.Ae = [An; 2*An(end-1,:); 3*An(end,:)];
S.be = [bn; 2*bn(end-1); 3*bn(end)];

% inequality constraints create a large polytope with a lot of redundant
% hyperplanes
A = randn(m,n);
b = 10*ones(m,1);

% remove infeasible inequalities
J = (A*xopt > b);
A(J,:) = [];
b(J,:) = [];

% assign inequalities
S.A = A;
S.b = b;

% random cost function
S.f = randn(n,1);

% assign solver
S.solver = solver;

% call mpt_solve
R = mpt_solve(S);

% compare results
if norm(R.xopt-xopt,Inf)>tol
    error('Results are not equal within a given tolerance.');
end

%mbg_asserttolequal(R.xopt,p.xopt,tol);
%mbg_asserttolequal(R.obj,p.fopt,tol);

end