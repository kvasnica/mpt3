function test_lp_solvers04(solver, tol)
% testing infeasibility
% 

global MPTOPTIONS

% initial data
% x1 <= -1 should not be feasible with lower bound x>=0
A = [1 0 0 0 0 0];

%b = -1;

%Aeq = ones(1,6);
%beq = 5;
%x0 = zeros(6,1);

% use old MPT interface to solve it
%[~,~,~,ef1] = mpt_solveLP(zeros(1,6),A,b,Aeq,beq,x0,solver,0*ones(6,1),10*ones(6,1));

% create structure S
S.f = zeros(1,6);
S.A = A;
S.b = -1;
S.Ae = ones(1,6);
S.be = 5;
S.lb = zeros(6,1);
S.solver = solver;

% call mpt_solve
R = mpt_solve(S);

if R.exitflag~=MPTOPTIONS.INFEASIBLE
    error('Result should be infeasible.');
end
%mbg_assertequal(R.exitflag,-1);

end