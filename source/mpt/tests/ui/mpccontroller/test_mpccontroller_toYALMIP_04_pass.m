function test_mpccontroller_toYALMIP_04_pass
% Y.internal.sdpsettings should be created

model = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
model.x.penalty = OneNormFunction(eye(2));
model.u.penalty = OneNormFunction(1);
M = MPCController(model, 1);
Y = M.toYALMIP();

assert(isstruct(Y.internal.sdpsettings));

end
