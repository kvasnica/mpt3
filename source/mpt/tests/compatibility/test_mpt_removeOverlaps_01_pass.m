function test_mpt_removeOverlaps_01_pass

A = [2 -1;1 0];
B1 = [1;0];  % Small gain for  x(1) > 0
B2 = [pi;0]; % Larger gain for x(1) < 0
C = [0.5 0.5];
nx = 2; % Number of states
nu = 1; % Number of inputs

% Prediction horizon
N = 3;

% States x(k), ..., x(k+N)
x = sdpvar(repmat(nx,1,N),repmat(1,1,N));
% Inputs u(k), ..., u(k+N) (last one not used)
u = sdpvar(repmat(nu,1,N),repmat(1,1,N));
% Binary for PWA selection
d = binvar(repmat(2,1,N),repmat(1,1,N));

constraints = [];
objective = 0;

for k = N-1:-1:1  

    % Feasible region
    constraints = [constraints , -1 < u{k}     < 1,
                                 -1 < C*x{k}   < 1,
                                 -5 < x{k}     < 5,
                                 -1 < C*x{k+1} < 1,
                                 -5 < x{k+1}   < 5];
    % PWA Dynamics
    constraints = [constraints ,implies(d{k}(1),x{k+1} == A*x{k}+B1*u{k}),
                                implies(d{k}(2),x{k+1} == A*x{k}+B2*u{k});
                                implies(d{k}(1),x{k}(1) > 0),
                                implies(d{k}(2),x{k}(1) < 0)];

    % It is EXTREMELY important to add as many
    % constraints as possible to the binary variables
    constraints = [constraints, sum(d{k}) == 1];

    % Add stage cost to total cost
    objective = objective + norm(x{k},1) + norm(u{k},1);
end

[sol,diagn,Z,Valuefcn,Optimizer] = ...
solvemp(constraints,objective ,[],x{1},u{1});

assert(length(sol)==1);
assert(length(sol{1}.Pn)==15);
assert(~sol{1}.overlaps);

end
