function test_empccontroller_04_pass
% import from MPCController

model = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
model.x.max = 5; model.x.min = -5;
model.u.max = 1; model.u.min = -1;
M = MPCController(model, 3);
M.model.x.penalty = Penalty(1, 2);
M.model.u.penalty = Penalty(1, 2);

E = EMPCController(M);

assert(E.nr==5);
assert(numel(E.optimizer)==1);
assert(E.N==M.N);

% test chaining
E = MPCController(M.model, 3).toExplicit();
assert(E.nr==5);
assert(E.N==M.N);

end
