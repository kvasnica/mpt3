function test_plcp_20_pass
% running in parallel

% start parallel mode
matlabpool

% setup the problem
model = LTISystem('A',[1 -0.4; 0.5 -1.2],'B',[1 -0.2;0.4 -4]);
model.x.min = [-5;-5];
model.x.max = [5;5];
model.u.min = [-1;-1];
model.u.max = [1;1];
ctrl = MPCController(model,5);
sol = ctrl.toExplicit;

% close the parallel mode
matlabpool close

if sol.partition.Num~=15
    error('Here should be 15 regions.');
end


end