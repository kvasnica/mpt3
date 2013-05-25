function test_polyunion_min_02_pass
% test two equal partitions, only one should remain

% mplp
model = LTISystem('A', 1, 'B', 1, 'C', 1);
model.x.min = -1; model.x.max = 1;
model.u.min = -1; model.u.max = 1;
model.x.penalty = OneNormFunction(1);
model.u.penalty = OneNormFunction(1);
E = MPCController(model, 2).toExplicit;
PUs = [E.optimizer E.optimizer];

Q = PUs.min('obj');
assert(Q.Num == E.optimizer.Num);

end
