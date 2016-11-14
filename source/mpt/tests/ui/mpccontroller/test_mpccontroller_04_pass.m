function test_mpccontroller_04_pass
% import from LTI/PWA/MLD

L = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
L.x.max = 5;
L.x.min = -4;
L.u.max = 3;
L.u.min = -2;

% basic syntax with just the model, should set N=[]
M = MPCController(L);
assert(isa(M.model, 'LTISystem'));
assert(isempty(M.N));

% check that we can set the horizon
M.N = 3;
assert(M.N==3);

% check that the model is a copy of what was provided
L.x.max = 6;
assert(M.model.x.max==5);
M.model.x.max = 4;
assert(L.x.max==6);

% model+horizon provided
M = MPCController(L, 5);
assert(isa(M.model, 'LTISystem'));
assert(M.N==5);

% pwa model
clear sysStruct probStruct
opt_sincos
P = PWASystem(sysStruct);
M = MPCController(P, 5);
assert(isa(M.model, 'PWASystem'));
assert(M.N==5);

% MLD model
model = MLDSystem('pwa_car');
M = MPCController(model, 2);
assert(isa(M.model, 'MLDSystem'));
assert(M.N==2);

end
