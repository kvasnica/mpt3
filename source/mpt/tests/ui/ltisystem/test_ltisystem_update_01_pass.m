function test_ltisystem_update_01_pass
% tests LTISystem/update() with non-autonomous system

nu = 2; nx = 3; ny = 4;

A = randn(nx); B = randn(nx, nu); 
C = randn(ny, nx); D = randn(ny, nu); 
f = randn(nx, 1); g = randn(ny, 1);
Ts = 1;

s = ss(A, B, C, D, Ts);
L = LTISystem('A', A, 'B', B, 'C', C, 'D', D, 'f', f, 'g', g);
x0 = randn(nx, 1);
u = randn(nu, 1);
xgood = A*x0+B*u+f;
ygood = C*x0+D*u+g;

L.initialize(x0);
L.update(u);
assert(isequal(L.getStates, xgood))

L.initialize(x0);
xn = L.update(u);
assert(isequal(L.getStates, xgood))
assert(isequal(xn, xgood))

L.initialize(x0);
[xn, y] = L.update(u);
assert(isequal(L.getStates, xgood))
assert(isequal(xn, xgood))
assert(isequal(y, ygood));

end

