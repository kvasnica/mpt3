function test_milp_solvers08(solver, tol)
% test program

% initial data
load data_test_milp08

% use old MPT interface to solve it
%[x,f,how,ex]=mpt_solveMILP(p.c,p.A,p.B,p.Aeq,p.Beq,p.l,p.u,p.vartype,[],[],solver);

% create structure
S.f = p.c;
S.A = p.A;
S.b = p.B;
S.Ae = p.Aeq;
S.be = p.Beq;
S.lb = p.l;
S.ub = p.u;
S.vartype = p.vartype;
S.solver = solver;

% solve
R = mpt_solve(S);

% compare results
if norm(R.xopt-p.xd,Inf)>tol
    error('Results are not equal within a given tolerance.');
end
if norm(R.obj-p.fd,Inf)>tol
    error('Results are not equal within a given tolerance.');
end

%mbg_asserttolequal(R.xopt,p.xd,tol);
%mbg_asserttolequal(R.obj,p.fd,tol);

end