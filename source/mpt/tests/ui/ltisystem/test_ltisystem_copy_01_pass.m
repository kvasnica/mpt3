function test_ltisystem_copy_01_pass
% tests copy()

nu = 2; nx = 3; ny = 4;
A = randn(nx); B = randn(nx, nu); 
C = randn(ny, nx); D = randn(ny, nu); Ts = rand;
L = LTISystem('A', A, 'B', B, 'C', C, 'D', D);
L.x.max = [1;2;3];
L.y.min = [-4; -5; -6; -7];

C = L.copy;
assert(isequal(C.A, L.A));
assert(isequal(C.B, L.B));
assert(isequal(C.C, L.C));
assert(isequal(C.D, L.D));
assert(isequal(C.x.max, L.x.max));
assert(isequal(C.y.min, L.y.min));

% copy() should brake the reference, test that
L.x.max = [4; 5; 6];
assert(isequal(C.x.max, [1;2;3]));

C.u.max = [2; 3];
assert(isequal(L.u.max, Inf(nu, 1)));

end

