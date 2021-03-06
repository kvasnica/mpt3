function test_lp_solvers07(solver, tol)
% test program
% n = 57; variables
% nc = 85; inequality constraints
% nceq = 12; equality constraints

fname = mfilename;
check_LPsolvers;

% initial data
load data_test_lp07

% use MPT interface to solve it
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