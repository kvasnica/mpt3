function test_mintime_06_pass
% EMinTimeController for PWA systems

opt_sincos
sysStruct.xmin = [-1.1; -1.1];
sysStruct.xmax = [1.1; 1.1];
sysStruct.umax = 2;
sysStruct.umin = -2;
model = mpt_import(sysStruct, probStruct);
model.x.with('terminalSet');
model.x.terminalSet = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);

% terminal set must be provided
ctrl = EMinTimeController(model);
assert(isa(ctrl, 'EMinTimeController'));
assert(ctrl.nr==50);

end
