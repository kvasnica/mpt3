function test_empccontroller_05_pass
% import from PolyUnion

% mplp/mplp
model = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
model.x.max = 5; model.x.min = -5;
model.u.max = 1; model.u.min = -1;
model.x.penalty = OneNormFunction(1);
model.u.penalty = OneNormFunction(1);
M = MPCController(model, 3);
Y = M.toYALMIP;

sol = solvemp(Y.constraints, Y.objective, [], ...
	Y.variables.x(:, 1), Y.variables.u(:));

% make sure the solution was indeed computed
assert(iscell(sol));

PU = mpt_mpsol2pu(sol);

E = EMPCController(PU);
assert(isempty(E.nu));

% check that we can change number of inputs from outside
E.nu = 1;
E.N = 3;
assert(E.nr==6 || E.nr==4 || E.nr==5); % 4 for plcp, 6 with mplp, check the cost
[~, ~, openloop] = E.evaluate(0.3);
Jgood = 0.6;
assert(norm(openloop.cost-Jgood)<1e-10);
assert(numel(E.optimizer)==1);

% check that we have associated correct functions
F = E.feedback.Set;
C = E.cost.Set;
S = E.optimizer.Set;
for i = 1:length(E.optimizer.Set)
	% primal
	Fprimal = F(i).getFunction('primal');
	Sprimal = S(i).getFunction('primal');
	assert(isequal(Fprimal.F, Sprimal.F));
	assert(isequal(Fprimal.g, Sprimal.g));
	% obj
	Cobj = C(i).getFunction('obj');
	Sobj = S(i).getFunction('obj');
	assert(isequal(Cobj.F, Sobj.F));
	assert(isequal(Cobj.g, Sobj.g));
end

end
