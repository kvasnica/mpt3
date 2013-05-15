function test_ltisystem_08_pass
% incomplete import from parameter/value pairs should set unspecified
% matrices to zeros

nu = 2; nx = 3; ny = 4;

A = randn(nx); B = randn(nx, nu); 
C = randn(ny, nx); D = randn(ny, nu); Ts = rand;

L = LTISystem('A', A, 'B', B, 'C', C);
assert(isequal(L.A, A));
assert(isequal(L.B, B));
assert(isequal(L.C, C));
assert(isequal(L.D, zeros(ny, nu)));

end

