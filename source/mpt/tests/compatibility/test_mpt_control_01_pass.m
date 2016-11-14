function test_mpt_control_01_pass
% basic test

Double_Integrator
probStruct.N = 1;
model = mpt_import(sysStruct, probStruct);

% explicit controller by default
ctrl = mpt_control(sysStruct, probStruct);
assert(isa(ctrl, 'EMPCController'));
assert(ctrl.N == probStruct.N);

% verify that the domain was set correctly
assert(isa(ctrl.partition.Domain, 'Polyhedron'));
assert(length(ctrl.partition.Domain)==1);
assert(ctrl.partition.convexHull == ctrl.partition.Domain);

% on-line controller on demand
ctrl = mpt_control(sysStruct, probStruct, 'on-line');
assert(isa(ctrl, 'MPCController'));
assert(ctrl.N == probStruct.N);

end
