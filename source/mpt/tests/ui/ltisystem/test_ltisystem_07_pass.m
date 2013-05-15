function test_ltisystem_07_pass
% tests LTISystem('A', A)

% we should allow to easily define autonomous systems by automatically
% setting non-defined terms to empty matrices of proper size

% only A:
nx = 3;
A = randn(nx);
L = LTISystem('A', A);
assert(isequal(L.nx, nx));
assert(isequal(L.ny, 0));
assert(isequal(L.nu, 0));
assert(isequal(L.A, A));
assert(isempty(L.B));
assert(isequal(L.f, zeros(3, 1)));
assert(isequal(size(L.B), [nx 0]));
assert(isequal(size(L.C), [0 nx]));
assert(isequal(size(L.D), [0 0]));

% A and C:
nx = 3; ny = 2;
A = randn(nx);
C = randn(ny, nx);
L = LTISystem('A', A, 'C', C);
assert(isequal(L.nx, nx));
assert(isequal(L.ny, ny));
assert(isequal(L.nu, 0));
assert(isequal(L.A, A));
assert(isequal(L.C, C));
assert(isempty(L.B));
assert(isequal(L.f, zeros(3, 1)));
assert(isequal(size(L.B), [nx 0]));
assert(isequal(size(L.D), [2 0]));
