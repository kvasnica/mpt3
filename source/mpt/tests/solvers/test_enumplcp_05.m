function test_enumplcp_05
% Testing hybrid MPC with equality constraints on binary variables
% with a pecific case where the rank of submatrix Ae(:,cont_vars) ~= 0
% 
% The goal of this test is to verify elimination of equality constraints
% for the above matrix.

% load FORD car model from
% Borrelli, F.; Bemporad, A. ; Fodor, M. ; Hrovat, D.
% An MPC/hybrid system approach to traction control 
% Control Systems Technology, IEEE Transactions on  (Volume:14 ,  Issue: 3 ) 

load car_pwa_model

% model the system manually using YALMIP
Q = diag(50);
R = diag(1);

horizon = 3;

x = sdpvar(pwa_model.nx,horizon+1);
u = sdpvar(pwa_model.nu,horizon);
y = sdpvar(pwa_model.ny,horizon);
d = binvar(pwa_model.ndyn,horizon);
ref = sdpvar(pwa_model.ny,1);

obj = 0;
con = [];
for i=1:horizon
    for j=1:pwa_model.ndyn
        % assign dynamics
        con = [ con;
            implies(d(j,i), pwa_model.domain(j).A*[x(:,i);u(:,i)] <= pwa_model.domain(j).b) ];

        % assing domain
        con = [con;
            implies(d(j,i), x(:,i+1) == pwa_model.A{j}*x(:,i) + pwa_model.B{j}*u(:,i) + pwa_model.f{j} ) ];
        
        % assign output
        con = [con;
            implies(d(j,i), y(:,i) == pwa_model.C{j}*x(:,i) + pwa_model.D{j}*u(:,i) + pwa_model.g{j} ) ];
        
    end
    % uncontrollable input
    con = [con;  u(2,i) == u(2,1)];
    
    % assign switching condition
    con = [con;   sum(d(:,i))==1 ];
    
    obj = obj + norm(Q*(y(:,i) - ref),1) + norm(R*u(1,i),1);
    
end

% formulate the problem
problem = Opt(con, obj, [x(2,1);x(3,1);x(1,1); u(2,1); ref], u(1,:));

% eliminate equations
problem.eliminateEquations;

% transform to LCP
problem.qp2lcp;
P1 = problem.copy;


P2 = Opt(con, obj, [x(2,1);x(3,1);x(1,1); u(2,1); ref], u(1,:));
P2.qp2lcp;

% P1 and P2 must be equal
if norm(P1.M-P2.M)>1e-5 || norm(P1.q-P2.q,Inf)>1e-5 || norm(P1.Q-P2.Q)>1e-5 || ...
        norm(P1.Ae-P2.Ae)>1e-5 || norm(P1.be-P2.be,Inf)>1e-5 || norm(P1.pE-P2.pE)>1e-5
    error('Two LCP transformations are not equal.');
end

% verify equivalence of MPMIQP/PLCP by solving the problems for 10 random parameters
for i=1:10

    x = 5*randn(5,1);
    res1 = mpt_solve(problem,x);
    res2 = mpt_solve(P2, x);
    
    if res1.exitflag~=res2.exitflag
        error('The exit statuses are not equal.');
    else
       if norm(res1.xopt-res2.xopt,Inf)>1e-5
           error('The solutions of two problems do not hold.');
       end
    end
        


end


