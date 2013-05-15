function test_ltisystem_toSS_01_fail
% LTISystem/toSS should fail if no sampling time is specified

nu = 2; nx = 3; ny = 4;

A = randn(nx); B = randn(nx, nu); 
C = randn(ny, nx); D = randn(ny, nu); Ts = rand;

L = LTISystem('A', A, 'B', B, 'C', C, 'D', D, 'Ts', []);
S = L.toSS();


end

