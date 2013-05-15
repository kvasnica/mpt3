function test_mpccontroller_03_pass
% import from sysStruct/probStruct (PWA)

% 1-norm cost
clear
opt_sincos;
probStruct.N = 3;
probStruct.norm = 1;
model = mpt_import(sysStruct, probStruct);
M = MPCController(model, probStruct.N);
assert(M.N==probStruct.N);
assert(isa(M.model, 'PWASystem'));
assert(M.model.x.penalty.norm==probStruct.norm);
assert(M.model.u.penalty.norm==probStruct.norm);
assert(isequal(M.model.x.penalty.Q, probStruct.Q));
assert(isequal(M.model.u.penalty.Q, probStruct.R));

% quadratic cost
clear
opt_sincos;
probStruct.N = 3;
probStruct.norm = 2;
model = mpt_import(sysStruct, probStruct);
M = MPCController(model, probStruct.N);
assert(M.N==probStruct.N);
assert(isa(M.model, 'PWASystem'));
assert(M.model.x.penalty.norm==probStruct.norm);
assert(M.model.u.penalty.norm==probStruct.norm);
assert(isequal(M.model.x.penalty.Q, probStruct.Q));
assert(isequal(M.model.u.penalty.Q, probStruct.R));

end
