function test_qp_solvers07(solver, tol)
% 
% n = 50; variables
% nc = 30; inequality constraints
% nceq = 10; equality constraints

fname = mfilename;
check_QPsolvers;

load data_test_qp07

% solution via MPT interface
%[x,~,~,ex,fval] = mpt_solveQP(p.H,p.f,p.A,p.B,p.Aeq,p.Beq,p.x0,solver);

% create structure S
S.H = p.H;
S.f = p.f;
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
if norm(R.lambda.ineqlin-p.lambda.ineqlin,Inf)>tol
    error('Multiplicators for inequalities are not equal within a given tolerance.');
end
if norm(R.lambda.eqlin-p.lambda.eqlin,Inf)>tol
    error('Multiplicators for equalities are not equal within a given tolerance.');
end

%mbg_asserttolequal(R.obj,p.fopt,tol);
%mbg_asserttolequal(R.xopt,p.xopt,tol);

end
