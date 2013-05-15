function test_ltisystem_update_02_pass
% tests LTISystem/update() with autonomous system

nu = 0; nx = 3; ny = 4;

A = randn(nx); B = randn(nx, nu);
C = randn(ny, nx); D = randn(ny, nu); 
Ts = 1;

s = ss(A, B, C, D, Ts);
L = LTISystem('A', A, 'B', B, 'C', C, 'D', D);
x0 = randn(nx, 1);
u = randn(nu, 1);
xgood = A*x0;
ygood = C*x0;

L.initialize(x0);
L.update();
assert(isequal(L.getStates, xgood))

L.initialize(x0);
xn = L.update();
assert(isequal(L.getStates, xgood))
assert(isequal(xn, xgood))

L.initialize(x0);
[xn, y] = L.update();
assert(isequal(L.getStates, xgood))
assert(isequal(xn, xgood))
assert(isequal(y, ygood));

end

