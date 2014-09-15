function test_closedloop_03_pass

Double_Integrator;
probStruct.Tconstraint = 0;
model = mpt_import(sysStruct, probStruct);
ctrl = MPCController(model, 1);

[~, msg] = run_in_caller('loop = ClosedLoop(model, sysStruct);');
asserterrmsg(msg, 'Invalid type of the second argument.');

end
