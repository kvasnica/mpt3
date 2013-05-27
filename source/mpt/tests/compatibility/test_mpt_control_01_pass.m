function test_mpt_control_01_pass
% basic test

Double_Integrator
probStruct.N = 1;
model = mpt_import(sysStruct, probStruct);

% explicit controller by default
ctrl = mpt_control(sysStruct, probStruct);
assert(isa(ctrl, 'EMPCController'));
assert(ctrl.N == probStruct.N);

% on-line controller on demand
ctrl = mpt_control(sysStruct, probStruct, 'on-line');
assert(isa(ctrl, 'MPCController'));
assert(ctrl.N == probStruct.N);

end
