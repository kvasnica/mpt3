function test_yset_22_pass
%
% hybrid MPC - fails because it is nonconvex set
%

A = [2 -1;1 0];
B1 = [1;0]; % Small gain for  x(1) > 0
B2 = [2;0]; % Larger gain for x(1) < 0
nx = 2; % Number of states
nu = 1; % Number of inputs

% MPC data
Q = eye(2);
R = 1;
N = 4;

u = sdpvar(nu,N);
x = sdpvar(nx,N+1);

constraints = [];
objective   = 0;
for k = 1:N
 objective = objective + norm(Q*x(:,k),1) + norm(R*u(k),1);

 Model1 = [x(:,k+1) == A*x(:,k) + B1*u(k), x(1,k) >= 0];
 Model2 = [x(:,k+1) == A*x(:,k) + B2*u(k), x(1,k) <= 0];

 constraints = [constraints, Model1 | Model2, -1 <= u(k)<= 1, -5<=x(:,k)<=5];
end

constraints = [constraints , -5<=x(:,k+1)<=5];

% eventually throw different error because of yalmip bug
[worked, msg] = run_in_caller('S = YSet([x(:);u(:); sdpvar(1)],constraints); ');
assert(~worked);
%asserterrmsg(msg,'Variables must be provided as vectors only.');

end