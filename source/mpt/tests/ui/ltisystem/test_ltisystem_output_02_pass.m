function test_ltisystem_output_02_pass
% LTISystem/output() with direct feedthrough should fail if no input is
% provided

nu = 2; nx = 3; ny = 4;

A = randn(nx); B = randn(nx, nu); 
C = randn(ny, nx); D = randn(ny, nu); 
Ts = 1;

s = ss(A, B, C, D, Ts);
L = LTISystem('A', A, 'B', B, 'C', C, 'D', D);
x0 = randn(nx, 1);

L.initialize(x0);
[worked, msg] = run_in_caller('L.output() ');
assert(~worked);
asserterrmsg(msg,'Input is required for systems with direct feed-through.');

end

