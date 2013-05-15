function test_mpccontroller_evaluate_01_fail
% MPCController/evaluate with wrong dimension of "x" should fail

Double_Integrator
probStruct.norm = 2;
probStruct.Tconstraint = 0; probStruct.P_N = eye(2);
model = mpt_import(sysStruct, probStruct);
M = MPCController(model, probStruct.N);
M.evaluate(ones(3, 1));

end
