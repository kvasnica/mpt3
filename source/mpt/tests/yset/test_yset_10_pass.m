function test_yset_10_pass
%
% standard MPC example
%

% Model data
A = [2 -1;1 0];
B = [1;0];
nu = 1; % Number of inputs

% MPC data
Q = eye(2);
R = 1;
N = 3;

% Initial state
x0 = [2;1];

% setup of optimization
u = sdpvar(nu,N);

constraints = [];
objective = 0;
x = x0;
for k = 1:N
 x = A*x + B*u(k);
 objective = objective + norm(Q*x,1) + norm(R*u(k),1);
 constraints = [constraints, -1 <= u(k)<= 1, -5<=x<=5];
end

S = YSet(u,constraints);
end