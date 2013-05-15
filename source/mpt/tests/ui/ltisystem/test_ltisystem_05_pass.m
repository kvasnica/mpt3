function test_ltisystem_05_pass
% import from parameter/value pairs

nu = 2; nx = 3; ny = 4;

A = randn(nx); B = randn(nx, nu); 
C = randn(ny, nx); D = randn(ny, nu); Ts = rand;

L = LTISystem('A', A, 'B', B, 'C', C, 'D', D, 'Ts', Ts);

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

