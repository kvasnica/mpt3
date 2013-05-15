function test_mpccontroller_fromYALMIP_02_pass
% check that MPCController/fromYALMIP is propaget by toExplicit

Double_Integrator
probStruct.norm = 2;
probStruct.N = 5;
probStruct.Tconstraint = 0; probStruct.P_N = eye(2);
model = mpt_import(sysStruct, probStruct);
M = MPCController(model, probStruct.N);
Y = M.toYALMIP;
Y.constraints = Y.constraints + [ -1 <= Y.variables.x <= 1 ];
M.fromYALMIP(Y);
E = M.toExplicit();
assert(E.nr==3);

end
