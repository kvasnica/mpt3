function test_ltisystem_02_fail
% wrong dimensions

nu = 2; nx = 3; ny = 4;

A = randn(nx); B = randn(nu, nu); 
C = randn(ny, nx); D = randn(ny, nu); Ts = rand;

L = LTISystem('A', A, 'B', B, 'C', C);

end

