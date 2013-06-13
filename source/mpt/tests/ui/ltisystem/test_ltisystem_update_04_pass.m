function test_ltisystem_update_04_pass
% LTISystem/update() with non-autonomous system should fail if no input is
% provided

nu = 2; nx = 3; ny = 4;

A = randn(nx); B = randn(nx, nu); 
C = randn(ny, nx); D = randn(ny, nu); 
f = randn(nx, 1); g = randn(ny, 1);
Ts = 1;

s = ss(A, B, C, D, Ts);
L = LTISystem('A', A, 'B', B, 'C', C, 'D', D, 'f', f, 'g', g);
x0 = randn(nx, 1);

L.initialize(x0);
[worked, msg] = run_in_caller('L.update(); ');
assert(~worked);
asserterrmsg(msg,'System is not autonomous, please provide the input.');

end

