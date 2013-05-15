function test_ltisystem_initialize_01_pass
% tests LTISystem/initialize()

nu = 2; nx = 3; ny = 4;

A = randn(nx); B = randn(nx, nu); 
C = randn(ny, nx); D = randn(ny, nu); 
f = randn(nx, 1); g = randn(ny, 1);
Ts = 1;
s = ss(A, B, C, D, Ts);
L = LTISystem('A', A, 'B', B, 'C', C, 'D', D, 'f', f, 'g', g);

% freshly created system should not be initialized
assert(isempty(L.getStates));

x0 = randn(nx, 1);
L.initialize(x0);
assert(isequal(L.getStates, x0));

end

