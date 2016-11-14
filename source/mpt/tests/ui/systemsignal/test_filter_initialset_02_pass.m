function test_filter_initialset_02_pass

model = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
model.x.min = [-1; -1];
model.x.max = [1; 1];
model.u.min = -1;
model.u.max = 1;
model.x.penalty = QuadFunction(eye(2));
model.u.penalty = QuadFunction(1);
model.x.with('initialSet');
model.x.initialSet = Polyhedron('lb', [-0.5; -0.5], 'ub', [0.5; 0.5]);

E = MPCController(model, 3).toExplicit();
assert(E.optimizer.Num==1);
assert(E.partition.Set==model.x.initialSet);

end
