function test_empccontroller_06_pass
% import from PolyUnion (same as test_empccontroller_06_pass, but with
% quadratic cost)

% mplp/mplp
model = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
model.x.max = 5; model.x.min = -5;
model.u.max = 1; model.u.min = -1;
model.x.penalty = Penalty(1, 2);
model.u.penalty = Penalty(1, 2);
M = MPCController(model, 3);
Y = M.toYALMIP;

sol = solvemp(Y.constraints, Y.objective, [], ...
	Y.variables.x(:, 1), Y.variables.u(:));

% make sure the solution was indeed computed
assert(iscell(sol));

PU = mpt_mpsol2pu(sol);
E = EMPCController(PU);
assert(isempty(E.nu));
assert(isempty(E.N));

assert(E.nr==5);
assert(numel(E.optimizer)==1);

% check that we have associated correct functions
F = E.feedback.Set;
C = E.cost.Set;
S = E.optimizer.Set;

Sfeedback = S.getFunction('primal');
Ffeedback = F.getFunction('primal');
Sobj = S.getFunction('obj');
Cobj = C.getFunction('obj');
for i = 1:length(E.optimizer.Set)
	% primal
	assert(isequal(Ffeedback(i).F, Sfeedback(i).F));
	assert(isequal(Ffeedback(i).g, Sfeedback(i).g));
	% obj
	assert(isequal(Cobj(i).H, Sobj(i).H));
	assert(isequal(Cobj(i).F, Sobj(i).F));
	assert(isequal(Cobj(i).g, Sobj(i).g));
end

% evaluate() requires non-empty prediction horizon
[worked, msg] = run_in_caller('E.evaluate(0.5);');
assert(~worked);
assert(~isempty(findstr(msg, 'The prediction horizon must be specified.')));
	
% evaluate() requires non-empty number of inputs
E.N = 3;
[worked, msg] = run_in_caller('E.evaluate(0.5);');
assert(~worked);
assert(~isempty(findstr(msg, 'Number of inputs must be specified.')));

% evaluate() should validate consistency of N and nu
E.N = 2; % should be 3, so test whether we inform the user
E.nu = 1;
[worked, msg] = run_in_caller('E.evaluate(0.5);');
assert(~worked);
assert(~isempty(findstr(msg, 'Number of optimizers is inconsistent with "N" and/or "nu".')));


% finally a correct evaluation
E.N = 3;
E.nu = 1;
[u, feasible, openloop] = E.evaluate(0.5);
Ugood = [-0.3, -0.1, 0];
Jgood = 0.4;
assert(feasible);
assert(norm(u-Ugood(:, 1))<1e-10);
assert(norm(openloop.U-Ugood)<1e-10);
assert(norm(openloop.cost-Jgood)<1e-10);
assert(all(all(isnan(openloop.X)))); % keep in sync with EMPCController/evaluate
assert(isequal(size(openloop.X), [E.nx E.N+1]));
assert(all(all(isnan(openloop.Y)))); % keep in sync with EMPCController/evaluate
assert(isequal(size(openloop.Y), [0 E.N]));

% swapping N and nu shouldn't be a problem and should lead to the open-loop
% sequence provided as the first element
E.N = 1;
E.nu = 3;
[u, ~, openloop] = E.evaluate(0.5);
Ugood = [-0.3; -0.1; 0];
Jgood = 0.4;
assert(norm(u-Ugood)<1e-10);
assert(norm(openloop.U-Ugood)<1e-10);
assert(norm(openloop.cost-Jgood)<1e-10);

% just one output argument
u = E.evaluate(0.5);
Ugood = [-0.3; -0.1; 0];
assert(norm(u-Ugood)<1e-10);

end
