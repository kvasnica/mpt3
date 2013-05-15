function test_mpccontroller_toYALMIP_01_pass
% tests MPCController/toYALMIP

Double_Integrator
probStruct.norm = 2;
probStruct.N = 5;
probStruct.Tconstraint = 0; probStruct.P_N = eye(2);
model = mpt_import(sysStruct, probStruct);
M = MPCController(model, probStruct.N);
Y = M.toYALMIP;
assert(isequal(size(Y.variables.x), [2 probStruct.N+1]));
assert(isequal(size(Y.variables.u), [1 probStruct.N]));
assert(isequal(size(Y.variables.y), [2 probStruct.N]));
assert(isa(Y.objective, 'sdpvar'));

end
