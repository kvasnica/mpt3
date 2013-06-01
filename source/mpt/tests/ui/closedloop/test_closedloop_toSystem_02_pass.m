function test_closedloop_toSystem_02_pass
% overlapping partitions and tracking controllers not yet supported

% reject overlapping partitions
opt_sincos;
probStruct.N = 1;
model = mpt_import(sysStruct, probStruct);
M = MPCController(model, probStruct.N).toExplicit;
assert(M.nr==6);
CL = ClosedLoop(M, model);
[~, msg] = run_in_caller('S = CL.toSystem');
asserterrmsg(msg, 'Overlapping partitions not supported.');

% reject tracking setups
L = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
L.x.penalty = QuadFunction(eye(2));
L.u.penalty = QuadFunction(1);
L.u.min = -1;
L.u.max = 1;
L.x.min = [-5; -5];
L.x.max = [5; 5];
L.x.with('reference');
L.x.reference = 'free';
ctrl = EMPCController(L, 1);
CL = ClosedLoop(ctrl, L);
[~, msg] = run_in_caller('S = CL.toSystem');
asserterrmsg(msg, 'Tracking controllers not supported.');


end
