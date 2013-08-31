function test_mintime_05_pass
% EMinTimeController for PWA systems

opt_sincos
sysStruct.xmin = [-1.5; -1.5];
sysStruct.xmax = [1.5; 1.5];
model = mpt_import(sysStruct, probStruct);

% terminal set must be provided
[~, msg] = run_in_caller('ctrl = EMinTimeController(model)');
asserterrmsg(msg, 'You must specify the terminal state set.');

end
