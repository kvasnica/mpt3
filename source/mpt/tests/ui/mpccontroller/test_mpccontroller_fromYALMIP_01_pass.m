function test_mpccontroller_fromYALMIP_01_pass
% tests MPCController/fromYALMIP

Double_Integrator
probStruct.norm = 2;
probStruct.N = 5;
probStruct.Tconstraint = 0; probStruct.P_N = eye(2);
model = mpt_import(sysStruct, probStruct);
M = MPCController(model, probStruct.N);
Y = M.toYALMIP;
Y.constraints = Y.constraints + [ -0.5 <= Y.variables.u(2) <= 0.5 ];
M.fromYALMIP(Y);

Ugood = [-1 -0.5 -0.311900733220533 0.34010152284264 0.325155104342922];
Jgood = 34.0922518330514;
[~, ~, openloop] = M.evaluate([4; 0]);
assert(norm(openloop.U-Ugood)<1e-6);
assert(norm(openloop.cost-Jgood)<1e-6);

end
