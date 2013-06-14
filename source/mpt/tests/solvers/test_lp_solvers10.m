function test_lp_solvers10(solver, tol)
% test program
% n = 234; variables
% nc = 78; inequality constraints
% nceq = 151; equality constraints

fname = mfilename;
check_LPsolvers;

% initial data
load data_test_lp10

% use MPT interface to solve it
%[x1,fval1] = mpt_solveLP(p.c',p.A,p.B,p.Aeq,p.Beq,p.x0,solver,p.l,p.u);

% create structure S
S.f = p.c;
S.A = p.A;
S.b = p.B;
S.Ae = p.Aeq;
S.be = p.Beq;
S.lb = p.l;
S.ub = p.u;
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