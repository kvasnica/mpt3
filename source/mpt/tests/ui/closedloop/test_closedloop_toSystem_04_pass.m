function test_closedloop_toSystem_04_pass
% toSystem for PWA systems

opt_sincos
probStruct.N = 2;
model = mpt_import(sysStruct, probStruct);
N = 2;
ctrl = EMPCController(model, N);
ctrl.optimizer = ctrl.optimizer.min('obj');
loop = ClosedLoop(ctrl, model);
sys = loop.toSystem();
assert(iscell(sys.A));
assert(length(sys.A)==ctrl.nr);

end
