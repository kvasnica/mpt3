function test_yset_12_pass
%
% robust mpc 
%

A = [2.938 -0.7345 0.25;4 0 0;0 1 0];
B = [0.25;0;0];
C = [-0.2072 0.04141 0.07256];
E = [0.0625;0;0];

N = 10;
U = sdpvar(N,1);
W = sdpvar(N,1);
x = sdpvar(3,1);

Y = [];
xk = x;
for k = 1:N
 xk = A*xk + B*U(k)+E*W(k);
 Y = [Y;C*xk];
end

% constraint sets
F = [Y <= 1, -1 <= U <= 1];
G = [-1 <= W <= 1];

% YSet
S = YSet([Y;U;W],[F;G]);

end