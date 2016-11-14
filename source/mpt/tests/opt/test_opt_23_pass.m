function test_opt_23_pass
%
% No degree of freedom left -  the problem is determined by construction


% 1 decision variable, 1 equality constraint.
% the optimizer is given by the equality constraint

%% MPT2.6 formulation
M.F = [1 1];
M.Y = zeros(2);
M.H = zeros(1, 0);
M.G = zeros(4, 0);
M.E = [-1 0;0 -1;0 1;1 0];
M.W = [1.1;2.2;-2;-1];
M.Cf = 1;
M.Cx = [1 1];
M.Cc = 0;
M.Aeq = [];
M.Beq = [];
M.beq = [];
M.bndA = [];
M.bndb = [];
M.nu = 0;
M.nx = 2;
M.qp = 0;
M.lb = -1e4*ones(2, 1);
M.ub = 1e4*ones(2, 1);
prb = Opt(M);
res = prb.solve;
if res.exitflag~=1
    error('The problem is feasible.');
end

%% the same problem but formulated in YALMIP
sdpvar x1 x2 x3

F1 = [ 1<=x1<=1.1; 2<=x2<=2.2; x3==x1+x2 ];

cost1 = x1+x2+x3;

prb1 = Opt(F1, cost1, [x1; x2], x3);
res1 = prb1.solve;
if res1.exitflag~=1
    error('The problem is feasible.');
end

%% if we add one more decision variable, the problem has one degree of
% freedom for optimization
sdpvar x4

F2 = [ 1<=x1<=1.1; 2<=x2<=2.2; x3+x4==x1+x2 ];

cost2 = x1+x2+x3+x4;
prb2 = Opt(F2, cost2, [x1; x2], [x3;x4]);
res2 = prb2.solve;
if res2.exitflag~=1
    error('The problem is feasible.');
end



end
