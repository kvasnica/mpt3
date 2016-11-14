function test_polytope_horzcat_01_pass
% test for issue #126

yalmip('clear')
% Model data
A = [2 -1;1 0];
B1 = [1;0];  % Small gain for  x(1) > 0
B2 = [pi;0]; % Larger gain for x(1) < 0
C = [0.5 0.5];
nx = 2; % Number of states
nu = 1; % Number of inputs
N = 4;
x = sdpvar(repmat(nx,1,N),repmat(1,1,N));
u = sdpvar(repmat(nu,1,N),repmat(1,1,N));
d = binvar(repmat(2,1,N),repmat(1,1,N));
constraints = [];
objective = 0;
for k = N-1:-1:1  

    constraints = [constraints , -1 <= u{k}     <= 1,
                                 -1 <= C*x{k}   <= 1,
                                 -5 <= x{k}     <= 5,
                                 -1 <= C*x{k+1} <= 1,
                                 -5 <= x{k+1}   <= 5];

    constraints = [constraints ,implies(d{k}(1),x{k+1} == A*x{k}+B1*u{k}),
                                implies(d{k}(2),x{k+1} == A*x{k}+B2*u{k});
                                implies(d{k}(1),x{k}(1) >= 0),
                                implies(d{k}(2),x{k}(1) <= 0)];

    constraints = [constraints, sum(d{k}) == 1];
    objective = objective + norm(x{k},1) + norm(u{k},1);
end
[sol,diagn,Z,Valuefcn,Optimizer] = solvemp(constraints,objective ,[],x{1},u{1});
plot(Valuefcn);
close all

end
