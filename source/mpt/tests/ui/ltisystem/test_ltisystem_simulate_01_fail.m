function test_ltisystem_simulate_01_fail
% LTISystem/simulate() should fail if simulating a non-autonomous system
% without providing a sequence of inputs

nu = 2; nx = 3; ny = 4;

A = randn(nx); B = randn(nx, nu); 
C = randn(ny, nx); D = randn(ny, nu); 
f = randn(nx, 1); g = randn(ny, 1);
Ts = 1;

s = ss(A, B, C, D, Ts);
L = LTISystem('A', A, 'B', B, 'C', C, 'D', D, 'f', f, 'g', g);
x0 = randn(nx, 1);

L.initialize(x0);
D = L.simulate();

end

