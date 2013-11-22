function test_pwasystem_isinvariant_01_pass

Double_Integrator

% not invariant here
probStruct.Nc = 1;
model = mpt_import(sysStruct, probStruct);
ctrl = EMPCController(model, 5);
s = ClosedLoop(ctrl, ctrl.model).toSystem();
answer = s.isInvariant();
assert(~answer);

% must be invariant here
probStruct.Nc = 2;
model = mpt_import(sysStruct, probStruct);
ctrl = EMPCController(model, 5);
s = ClosedLoop(ctrl, ctrl.model).toSystem();
answer = s.isInvariant();
assert(answer);

end
