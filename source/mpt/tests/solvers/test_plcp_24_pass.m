function test_plcp_24_pass
% test problem send by Andrea Zanelli that was complaining on warnings in
% the feasible set

% if the test does show holes in the solution, then it is ok
load('model_test_plcp_24.mat');
N = 5;
mpc = MPCController(model, N);
expmpc = mpc.toExplicit();

% the result is compared to 197 regions that have obtained by LCP and
% GUROBI solvers 
if expmpc.optimizer.Num~=197
    error('The number of regions does not hold.');
end

end