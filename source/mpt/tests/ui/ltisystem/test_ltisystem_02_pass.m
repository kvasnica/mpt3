function test_ltisystem_02_pass
% import from discrete-time state space objects

nu = 2; nx = 3; ny = 4;

A = randn(nx); B = randn(nx, nu); 
C = randn(ny, nx); D = randn(ny, nu); Ts = rand;

s = ss(A, B, C, D, Ts);
L = LTISystem(s);

assert(isequal(L.A, A));
assert(isequal(L.B, B));
assert(isequal(L.C, C));
assert(isequal(L.D, D));
assert(isequal(L.f, zeros(nx, 1)));
assert(isequal(L.g, zeros(ny, 1)));
assert(isequal(L.Ts, Ts));
assert(isequal(L.nx, nx));
assert(isequal(L.nu, nu));
assert(isequal(L.ny, ny));
assert(isequal(L.u.min, -Inf(nu, 1)))
assert(isequal(L.u.max, Inf(nu, 1)))
assert(isequal(L.x.min, -Inf(nx, 1)))
assert(isequal(L.x.max, Inf(nx, 1)))
assert(isequal(L.y.min, -Inf(ny, 1)))
assert(isequal(L.y.max, Inf(ny, 1)))

end

