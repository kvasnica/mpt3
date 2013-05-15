function test_opt_y2opt_01_pass
% test of opt constructor accepts yalmip data
%

% random data 
A = randn(2);
B = randn(2,1);
xlb = -5;
xub = 5;
ulb = -1;
uub = 1;

N = 5;
d = 2;
m = 1;

Q = eye(d);
R = eye(m);

% construct MPC problem in YALMIP 
x = sdpvar(d,N,'full');
u = sdpvar(m,N-1,'full');

cost = 0;
F = [];
for i=1:N-1
  F = F + set(x(:,i+1) == A*x(:,i) + B*u(:,i));
  F = F + set(xlb <= x(:,i) <= xub);
  F = F + set(ulb <= u(:,i) <= uub);

  if i > 1
    cost = cost + x(:,i)'*Q*x(:,i);
  end
  cost = cost + u(:,i)'*R*u(:,i);
end
F = F + set(xlb <= x(:,end) <= xub);
cost = cost + x(:,end)'*Q*x(:,end);

% convert to MPT3.0 format
P = Opt(F, cost, x(:,1), u(:));

% solve
%res = P.solve;

% plot
%plot(res.regions)

end