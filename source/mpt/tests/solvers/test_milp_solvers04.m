function test_milp_solvers04(solver, tol)
% testing infeasibility
% 
global MPTOPTIONS

fname = mfilename;
check_MILPsolvers;

% initial data
% x1 <= -1 should not be feasible with lower bound x>=0
A = [1 0 0 0 0 0];

b = -1;

Aeq = ones(1,6);
beq = 5;
x0 = zeros(6,1);

% use MPT interface to solve it
vartype = ['C' 'B' 'C' 'C' 'C' 'B']';
%[~,~,~,ef1] = mpt_solveMILP(zeros(1,6),A,b,Aeq,beq,0*ones(6,1),10*ones(6,1),vartype,[],[],solver);

% create structure
S.f = zeros(1,6);
S.A = A;
S.b = b;
S.Ae = Aeq;
S.be = beq;
S.lb = zeros(6,1);
S.ub = 10*ones(6,1);
S.vartype = char(vartype);
S.solver = solver;

R = mpt_solve(S);

if R.exitflag~=MPTOPTIONS.INFEASIBLE
    error('Result should be infeasible.');
end
%mbg_assertequal(R.exitflag,-1);

end