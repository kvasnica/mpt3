function test_ltisystem_setDomain_01_fail
% LTISystem/setDomain() should fail on incorrect dimenensions

nu = 0; nx = 3; ny = 4;

A = randn(nx); B = randn(nx, nu); 
C = randn(ny, nx); D = randn(ny, nu); 
f = randn(nx, 1); g = randn(ny, 1);
Ts = 1;

s = ss(A, B, C, D, Ts);
L = LTISystem('A', A, 'B', B, 'C', C, 'D', D, 'f', f, 'g', g);

% domain in the state space
nx = nx+1;
X = Polyhedron('lb', -ones(nx, 1), 'ub', 2*ones(nx, 1));
U = L.u.boundsToPolyhedron();
L.setDomain('x', X);

end
