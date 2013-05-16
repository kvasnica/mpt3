function test_plcp_22_pass
% benchmark for testing speed of PLCP solver with LCP 

Ts = 1;
Ac = [0 -1 1; 0 0 0; 0 0 0]; Bc = [0; 1; 0];
Cc = eye(3); Dc = zeros(3, 1);
sd = c2d(ss(Ac, Bc, Cc, Dc), Ts);
A = sd.A; B = sd.B; C = sd.C; D = sd.D;

N = 5;
umin = -3; umax = 3;
xmin = [0.1; 0; 0]; xmax = [20; 15; 15];
nx = length(xmin); nu = length(umin);

x = sdpvar(nx, N+1);
u = sdpvar(nu, N);
dref = sdpvar(1);
Qd = 100; Qv = 1e-2*eye(2); Qa = 1e-2;
con = [];
obj = 0;
for k = 1:N
        con = con + [ x(:, k+1) == A*x(:, k) + B*u(:, k) ];
        con = con + [ xmin <= x(:, k) <= xmax ];
        con = con + [ umin <= u(:, k) <= umax ];
        obj = obj + Qd*(x(1, k)-dref)^2 + ...
                x(2:3, k)'*Qv*x(2:3, k) + ...
                u(:, k)'*Qa*u(:, k);
end
con = con + [ xmin(1) <= dref <= xmax(1) ];
con = con + [ xmin <= x(:, N+1) <= xmax ];
obj = obj + Qd*(x(1, N+1)-dref)^2 + x(2:3, k)'*Qv*x(2:3, k);

t=clock; 
sol = solvemp(con, obj, sdpsettings('debug', 1), [x(:, 1); dref], u(1));

etime(clock, t)

if ~any(length(sol{1}.Pn)~=[826,827])
    error('The number of regions does not match.');
end

end