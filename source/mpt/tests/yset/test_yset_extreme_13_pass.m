function test_yset_extreme_13_pass
%
% matrix variable, wrong assignment
%

P = sdpvar(2);
A =  [-0.98698      -1.5855
       1.7663      0.80514];

F = [P>=0, A'*P + P*A <= -diag([0.1,0.2])];

S = YSet(P(:),F);

% V must be symmetric, but is not
V = [ -1.1453
      0.5
      0.6
      -2.7078];
[worked, msg] = run_in_caller('s = S.extreme(V); ');
assert(~worked);
asserterrmsg(msg,'Inconsistent assignment');


end
