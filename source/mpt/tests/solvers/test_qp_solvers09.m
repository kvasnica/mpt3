function test_qp_solvers09(solver, tol)
% 
% n = 185; variables
% nc = 124; inequality constraints
% nceq = 86; equality constraints

load data_test_qp09

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

%mbg_asserttolequal(R.obj,p.fopt,tol);
%mbg_asserttolequal(R.xopt,p.xopt,tol);

end
