function test_empccontroller_evaluate_03_pass
% tests MPCController/evaluate (import from solvemp)

% mplp
model = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
model.x.max = 5; model.x.min = -5;
model.u.max = 1; model.u.min = -1;
model.x.penalty = OneNormFunction(1);
model.u.penalty = OneNormFunction(1);
M = MPCController(model, 3);
Y = M.toYALMIP;

sol = solvemp(Y.constraints, Y.objective, [], ...
	Y.variables.x(:, 1), Y.variables.u(:));
PU = mpt_mpsol2pu(sol);
Eimp = EMPCController(PU);
Eimp.nu = 1;
Eimp.N = 3;
Empc = M.toExplicit();

[u, ~, openloop] = Empc.evaluate(3);
[uimp, ~, openloop_imp] = Eimp.evaluate(3);
assert(norm(openloop.cost-openloop_imp.cost)<1e-10);

% we can't always safely compare the optimizer due to non-uniqueness
try
	assert(norm(openloop.U-openloop_imp.U)<1e-10);
catch
	% at least the first element must be identical
	fprintf('Rigorous check of open-loop sequence failed, testing 1st element.\n');
	assert(norm(u-uimp)<1e-10);
end

% mpqp
model = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
model.x.max = 5; model.x.min = -5;
model.u.max = 1; model.u.min = -1;
model.x.penalty = QuadFunction(1);
model.u.penalty = QuadFunction(1);
M = MPCController(model, 3);
Y = M.toYALMIP;
sol = solvemp(Y.constraints, Y.objective, sdpsettings('debug', 1), ...
	Y.variables.x(:, 1), Y.variables.u(:));
PU = mpt_mpsol2pu(sol);
Eimp = EMPCController(PU);
Eimp.nu = 1;
Eimp.N = 3;
Empc = M.toExplicit();

[~, ~, openloop] = Empc.evaluate(3);
[~, ~, openloop_imp] = Eimp.evaluate(3);
assert(norm(openloop.U-openloop_imp.U)<1e-10);
assert(norm(openloop.cost-openloop_imp.cost)<1e-10);


end
