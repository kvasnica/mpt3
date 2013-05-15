function test_lp_solvers06(solver, tol)
% test program
% n = 144; variables
% nc = 155; inequality constraints
% nceq = 68; equality constraints

% initial data
load data_test_lp06

% use old MPT interface to solve it
%[x1,fval1] = mpt_solveLP(p.c',p.A,p.B,p.Aeq,p.Beq,p.x0,solver);

% create structure S
S.f = p.c;
S.A = p.A;
S.b = p.B;
S.Ae = p.Aeq;
S.be = p.Beq;
S.solver = solver;

% call mpt_solve
R = mpt_solve(S);

% compare results
if norm(R.xopt-p.xopt,Inf)>tol
    error('Results are not equal within a given tolerance.');
end
if norm(R.obj-p.fopt,Inf)>tol
    error('Results are not equal within a given tolerance.');
end

%mbg_asserttolequal(R.xopt,p.xopt,tol);
%mbg_asserttolequal(R.obj,p.fopt,tol);

end