function test_ltisystem_simulate_02_pass
% tests LTISystem/simulate() with an autonomous system

nu = 0; nx = 3; ny = 4;

A = randn(nx); B = randn(nx, nu); 
C = randn(ny, nx); D = randn(ny, nu); 
f = randn(nx, 1); g = randn(ny, 1);
Ts = 1;

s = ss(A, B, C, D, Ts);
L = LTISystem('A', A, 'B', B, 'C', C, 'D', D, 'f', f, 'g', g);
x0 = randn(nx, 1);
Nsim = 10;
U = randn(nu, Nsim);
X = x0; Y = [];
for i = 1:Nsim
	Y = [Y C*x0+D*U(:, i)+g];
	X = [X A*x0+B*U(:, i)+f];
	x0 = X(:, end);
end

L.initialize(X(:, 1));
D = L.simulate(U);
assert(isequal(D.X, X));
assert(isequal(D.U, U));
assert(isequal(D.Y, Y));

end

