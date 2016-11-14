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
assert(isa(M.model.x.penalty, 'OneNormFunction'));
assert(isa(M.model.u.penalty, 'OneNormFunction'));
assert(isequal(M.model.x.penalty.weight, probStruct.Q));
assert(isequal(M.model.u.penalty.weight, probStruct.R));

% quadratic cost
clear
opt_sincos;
probStruct.N = 3;
probStruct.norm = 2;
model = mpt_import(sysStruct, probStruct);
M = MPCController(model, probStruct.N);
assert(M.N==probStruct.N);
assert(isa(M.model, 'PWASystem'));
assert(isa(M.model.x.penalty, 'QuadFunction'));
assert(isa(M.model.u.penalty, 'QuadFunction'));
assert(isequal(M.model.x.penalty.weight, probStruct.Q));
assert(isequal(M.model.u.penalty.weight, probStruct.R));

end
