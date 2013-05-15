function test_yset_09_pass
%
% LPV example
%

Anominal = [0 1 0;0 0 1;0 0 0];
B = [0;0;1];
Q = eye(3);
R = 1;

A1 = Anominal;A1(1,3) = -0.1;
A2 = Anominal;A2(1,3) =  0.1;

Y = sdpvar(3,3);
L = sdpvar(1,3,'full');

F = [Y >= 0];
F = [F, [-A1*Y-B*L + (-A1*Y-B*L)' Y L';Y inv(Q) zeros(3,1);L zeros(1,3) inv(R)] >= 0];
F = [F, [-A2*Y-B*L + (-A2*Y-B*L)' Y L';Y inv(Q) zeros(3,1);L zeros(1,3) inv(R)] >= 0];

S = YSet([Y(:);L(:)],F);
end
