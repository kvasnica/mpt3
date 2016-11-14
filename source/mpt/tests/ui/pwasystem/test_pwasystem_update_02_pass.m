function test_pwasystem_update_02_pass
% tests PWASystem/update() with autonomous systems

opt_sincos;
sysStruct.A = { eye(2), -eye(2) };
sysStruct.B = { zeros(2, 0), zeros(2, 0) };
sysStruct.D = { zeros(2, 0), zeros(2, 0) };
sysStruct.umax = []; sysStruct.umin = [];
sysStruct = rmfield(sysStruct, 'dumax');
sysStruct = rmfield(sysStruct, 'dumin');
L = PWASystem(sysStruct);

% first dynamics
x0 = -[2; 2]; xgood = sysStruct.A{1}*x0; u = [];
L.initialize(x0);
L.update(u);
assert(norm(L.getStates-xgood) < 1e-12);

L.initialize(x0);
xn=L.update();
assert(norm(L.getStates-xgood) < 1e-12);
assert(norm(xn-xgood) < 1e-12);

L.initialize(x0);
[xn, y]=L.update(u);
assert(norm(L.getStates-xgood) < 1e-12);
assert(norm(xn-xgood) < 1e-12);
assert(isequal(y, x0)); % since C=I, D=0, g=0

% second dynamics
x0 = [2; 2]; xgood = sysStruct.A{2}*x0;
L.initialize(x0);
L.update();
assert(isequal(L.getStates, xgood));

L.initialize(x0);
xn=L.update();
assert(norm(L.getStates-xgood) < 1e-12);
assert(norm(xn-xgood) < 1e-12);

L.initialize(x0);
[xn, y]=L.update();
assert(norm(L.getStates-xgood) < 1e-12);
assert(norm(xn-xgood) < 1e-12);
assert(isequal(y, x0)); % since C=I, D=0, g=0


end

