function test_qp_solvers10(solver, tol)
% testing infeasibility

global MPTOPTIONS

load data_test_qp10

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

if R.exitflag~=MPTOPTIONS.INFEASIBLE
    error('Result should be infeasible.');
end
%mbg_asserttrue(R.exitflag<1);


end
