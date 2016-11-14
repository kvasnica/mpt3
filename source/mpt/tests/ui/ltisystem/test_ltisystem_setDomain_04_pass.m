function test_ltisystem_setDomain_04_pass
% LTISystem/setDomain() should fail on incorrect dimenensions

nu = 2; nx = 3; ny = 4;

A = randn(nx); B = randn(nx, nu); 
C = randn(ny, nx); D = randn(ny, nu); 
f = randn(nx, 1); g = randn(ny, 1);
Ts = 1;

s = ss(A, B, C, D, Ts);
L = LTISystem('A', A, 'B', B, 'C', C, 'D', D, 'f', f, 'g', g);

% domain in the input space
nu = nu+1;
X = L.x.boundsToPolyhedron();
U = Polyhedron('lb', -3*ones(nu, 1), 'ub', 4*ones(nu, 1));
[worked, msg] = run_in_caller('L.setDomain(''u'', U); ');
assert(~worked);
asserterrmsg(msg,'The domain must have dimension 2.');

end
