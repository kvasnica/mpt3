function test_ltisystem_toSS_01_pass
% tests LTISystem/toSS for systems without affine terms

nu = 2; nx = 3; ny = 4;

A = randn(nx); B = randn(nx, nu); 
C = randn(ny, nx); D = randn(ny, nu); Ts = rand;

L = LTISystem('A', A, 'B', B, 'C', C, 'D', D, 'Ts', Ts);
S = L.toSS();

assert(isa(S, 'ss'));
assert(isequal(S.A, L.A));
assert(isequal(S.B, L.B));
assert(isequal(S.C, L.C));
assert(isequal(S.D, L.D));
assert(isequal(S.Ts, L.Ts));

end

