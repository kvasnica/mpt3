function test_pwasystem_update_01_pass
% tests PWASystem/update()

opt_sincos;
L = PWASystem(sysStruct);

% first dynamics
x0 = [2; 2]; u = 1;
xgood = [-0.585640646055102; 3.1856406460551];
L.initialize(x0);
L.update(u);
assert(norm(L.getStates-xgood) < 1e-12);

L.initialize(x0);
xn=L.update(u);
assert(norm(L.getStates-xgood) < 1e-12);
assert(norm(xn-xgood) < 1e-12);

L.initialize(x0);
[xn, y]=L.update(u);
assert(norm(L.getStates-xgood) < 1e-12);
assert(norm(xn-xgood) < 1e-12);
assert(isequal(y, x0)); % since C=I, D=0, g=0

% second dynamics
x0 = -[2; 2]; u = 1;
xgood = [-2.1856406460551; 1.5856406460551];
L.initialize(x0);
L.update(u);
assert(norm(L.getStates-xgood) < 1e-12);

L.initialize(x0);
xn=L.update(u);
assert(norm(L.getStates-xgood) < 1e-12);
assert(norm(xn-xgood) < 1e-12);

L.initialize(x0);
[xn, y]=L.update(u);
assert(norm(L.getStates-xgood) < 1e-12);
assert(norm(xn-xgood) < 1e-12);
assert(isequal(y, x0)); % since C=I, D=0, g=0

end

