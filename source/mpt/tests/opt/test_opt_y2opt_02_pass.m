function test_opt_y2opt_02_pass
%
% use random data for creation of OWN MPC
%

global MPTOPTIONS

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
  F = [F; (x(:,i+1) == A*x(:,i) + B*u(:,i))];
  F = [F; (xlb*(1-0.1*i) <= x(:,i) <= xub*(1-0.1*i))]; % use contractive constraints
  F = [F; (ulb <= u(:,i) <= uub)];
  
  if i > 1
    cost = cost + x(:,i)'*Q*x(:,i);
  end
  cost = cost + u(:,i)'*R*u(:,i);
end
% equality constraints on the end of horizon
F = [F; ( x(:,end) == x(:,end-1) )];

cost = cost + x(:,end)'*Q*x(:,end);

% convert to MPT3.0 format
P = Opt(F, cost, x(:,1), u(:));

% solve
res = P.solve;

% solve using mpt2
SOL = solvemp(F,cost,sdpsettings('verbose',0),x(:,1),u(:));

[isin,inwhich1]=isInside(res.xopt.Set,[0;0]);
[isin,inwhich2]=isinside(SOL{1}.Pn,[0;0]);

if norm(res.xopt.Set(inwhich1).Functions('primal').F-SOL{1}.Fi{inwhich2})>MPTOPTIONS.rel_tol
    error('Wrong computation of control law.');
end

end
