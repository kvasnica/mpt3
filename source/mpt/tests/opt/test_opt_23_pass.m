function test_opt_23_pass
%
% Empty problem because there is no degree of freedom left.
% 1 decision variable, 1 equality constraint.
%
% the optimizer is given by the equality constraint

sdpvar x1 x2 x3

F1 = [ 1<=x1<=1.1; 2<=x2<=2.2; x3==x1+x2 ];

cost1 = x1+x2+x3;

[worked1, msg1] = run_in_caller('prb1 = Opt(F1, cost1, [x1; x2], x3);');

assert(~worked1)

asserterrmsg(msg1, 'Opt: Overdetermined system, no degrees of freedom.')

% if we add one more decision variable, the problem can be solved
sdpvar x4

F2 = [ 1<=x1<=1.1; 2<=x2<=2.2; x3+x4==x1+x2 ];

cost2 = x1+x2+x3+x4;
[worked, msg] = run_in_caller('prb2 = Opt(F2, cost2, [x1; x2], [x3;x4]);');

assert(worked)


end
