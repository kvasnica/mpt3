function test_ltisystem_setDomain_02_pass
% tests LTISystem/setDomain() with autonomous systems

nu = 0; nx = 3; ny = 4;

A = randn(nx); B = randn(nx, nu); 
C = randn(ny, nx); D = randn(ny, nu); 
f = randn(nx, 1); g = randn(ny, 1);
Ts = 1;

s = ss(A, B, C, D, Ts);
L = LTISystem('A', A, 'B', B, 'C', C, 'D', D, 'f', f, 'g', g);


% LTISystem constructor should automatically compute the x-u domain using
% constraints
assert(isequal(L.domain.Dim, nx+nu));
assert(isequal(L.domainx.Dim, nx));

% domain in the state space
X = Polyhedron('lb', -ones(nx, 1), 'ub', 2*ones(nx, 1));
U = L.u.boundsToPolyhedron();
L.setDomain('x', X);
assert(L.domain.Dim==nx+nu);
assert(L.domain==X*U);

% domain in the input space
X = L.x.boundsToPolyhedron();
U = Polyhedron('lb', -3*ones(nu, 1), 'ub', 4*ones(nu, 1));
L.setDomain('u', U);
assert(L.domain.Dim==nx+nu);
assert(L.domain==X*U);

% domain in the state-input space
X = Polyhedron('lb', -ones(nx, 1), 'ub', 2*ones(nx, 1));
U = Polyhedron('lb', -3*ones(nu, 1), 'ub', 4*ones(nu, 1));
L.setDomain('xu', X*U);
assert(L.domain.Dim==nx+nu);
assert(L.domain==X*U);

end
