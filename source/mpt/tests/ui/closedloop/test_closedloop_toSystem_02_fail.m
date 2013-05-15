function test_closedloop_toSystem_02_fail
% overlapping partitions not yet supported

opt_sincos;
probStruct.N = 1;
model = mpt_import(sysStruct, probStruct);
M = MPCController(model, probStruct.N).toExplicit;
assert(M.nr==6);

CL = ClosedLoop(M, model);
S = CL.toSystem;

end
