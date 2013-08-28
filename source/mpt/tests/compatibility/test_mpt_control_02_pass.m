function test_mpt_control_02_pass
% overlaps should be removed if possible

opt_sincos;
probStruct.N=2;

ctrl = mpt_control(sysStruct, probStruct);
% single optimizer should be returned since overlaps were removed
assert(numel(ctrl.optimizer)==1);
assert(ctrl.optimizer.Num==16);

% no removal of overlaps for quadratic cost
probStruct.norm = 2;
ctrl = mpt_control(sysStruct, probStruct);
assert(numel(ctrl.optimizer)==4);
assert(ctrl.nr==10);


end
