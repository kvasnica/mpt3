function test_yset_contains_09_pass
%
% 3D test containment, x must be a column
%

x = sdpvar(2,1);

F1 = (randn(2)*x<=randn(2,1));
F2 = (randn(2)*x<=randn(2,1));

S1 = YSet(x,F1);
S2 = YSet(x,F2);

S = [S1,S2];

% wrong dimension of x
x = randn(1, 2);
[~, msg] = run_in_caller('S.contains(x)');
asserterrmsg(msg, 'The point must have 2 rows.');

% correct dimension
S.contains(randn(2,1));


end
