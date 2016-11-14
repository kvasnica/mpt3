function test_ltisystem_initialize_02_pass
% tests LTISystem/initialize() with wrong dimension of the state

nu = 2; nx = 3; ny = 4;

A = randn(nx); B = randn(nx, nu); 
C = randn(ny, nx); D = randn(ny, nu); 
f = randn(nx, 1); g = randn(ny, 1);
Ts = 1;

s = ss(A, B, C, D, Ts);
L = LTISystem('A', A, 'B', B, 'C', C, 'D', D, 'f', f, 'g', g);

x0 = randn(nx-1, 1);
[worked, msg] = run_in_caller('L.initialize(x0); ');
assert(~worked);
asserterrmsg(msg,'The initial state must be a 3x1 vector.');

end

