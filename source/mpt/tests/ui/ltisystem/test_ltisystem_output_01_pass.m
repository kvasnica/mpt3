function test_ltisystem_output_01_pass
% tests LTISystem/output() with no direct feedthrough

nu = 2; nx = 3; ny = 4;

A = randn(nx); B = randn(nx, nu); 
C = randn(ny, nx); D = 0*randn(ny, nu); 
f = randn(nx, 1); g = randn(ny, 1);
Ts = 1;

s = ss(A, B, C, D, Ts);
L = LTISystem('A', A, 'B', B, 'C', C, 'D', D, 'f', f, 'g', g);
x0 = randn(nx, 1);
u = randn(nu, 1);
ygood = C*x0+D*u+g;

L.initialize(x0);
assert(isequal(L.output, ygood));

end

