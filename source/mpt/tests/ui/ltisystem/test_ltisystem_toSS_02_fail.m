function test_ltisystem_toSS_02_fail
% LTISystem/toSS should fail system has affine terms

nu = 2; nx = 3; ny = 4;

A = randn(nx); B = randn(nx, nu); 
C = randn(ny, nx); D = randn(ny, nu); Ts = rand;
f = randn(nx, 1);

L = LTISystem('A', A, 'B', B, 'C', C, 'D', D, 'f', f, 'Ts', Ts);
S = L.toSS();

end

