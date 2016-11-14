function test_empccontroller_dp_01_pass
% dynamic programming via PWApenalty

model = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
model.x.min = [-5; -5];
model.x.max = [5; 5];
model.u.min = -1;
model.u.max = 1;
model.x.penalty = OneNormFunction(eye(2));
model.u.penalty = OneNormFunction(1);

N = 3; % should get 5 regions
E = {};

% obtain terminal cost with horizon 1
model.x.with('terminalPenalty');
model.x.terminalPenalty = OneNormFunction(eye(2));
E{1} = EMPCController(model, 1);

% remove the terminalPenalty filter since it conflicts with PWApenalty
model.x.without('terminalPenalty');

% add PWA terminal penalty
model.x.with('PWApenalty');
model.x.PWApenalty.function = 'obj';
model.x.PWApenalty.isconvex = true;
model.x.PWApenalty.step = 2; % penalization of terminal state

for k = 2:N
	% take cost-to-go from the previous step
	model.x.PWApenalty.polyunion = E{k-1}.optimizer;
	E{k} = EMPCController(model, 1);
end

% must get 50 regions with N=3
assert(E{N}.nr==50);

end
