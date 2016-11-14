function test_ltisystem_backreach_03_pass
% LTISystem/reachableSet with non-autonomous without affine terms
% (backkwards)

% N = 1 (default)
sys = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
X = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
U = Polyhedron('lb', -1, 'ub', 1);
preX = sys.reachableSet('X', X, 'U', U, 'direction', 'back');
assert(length(preX)==1);
assert(isa(preX, 'Polyhedron'));
assert(preX.Dim==2);

At = [sys.A, sys.B; zeros(1, 2), 1];
ft = zeros(3, 1);
Z = X*U;
Ht = Z.A*At;
Kt = Z.b-Z.A*ft;
preXgood = Polyhedron(Ht, Kt).projection(1:2);
assert(preX==preXgood);


% N=1
sys = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
X = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
U = Polyhedron('lb', -1, 'ub', 1);
preX = sys.reachableSet('X', X, 'U', U, 'N', 1, 'direction', 'back');
assert(length(preX)==1);
assert(isa(preX, 'Polyhedron'));
assert(preX.Dim==2);

At = [sys.A, sys.B; zeros(1, 2), 1];
ft = zeros(3, 1);
Z = X*U;
Ht = Z.A*At;
Kt = Z.b-Z.A*ft;
preXgood = Polyhedron(Ht, Kt).projection(1:2);
assert(preX==preXgood);

% autonomous system, N=2
sys = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
X = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
U = Polyhedron('lb', -1, 'ub', 1);
[preX, preN] = sys.reachableSet('X', X, 'U', U, 'N', 2, 'direction', 'back');
assert(isa(preX, 'Polyhedron'));
assert(length(preX)==1);
assert(iscell(preN));
assert(length(preN)==2);
assert(isa(preN{1}, 'Polyhedron'));
assert(isa(preN{2}, 'Polyhedron'));

At = [sys.A, sys.B; zeros(1, 2), 1];
ft = zeros(3, 1);
Z = X*U;
Ht = Z.A*At;
Kt = Z.b-Z.A*ft;
preXgood = Polyhedron(Ht, Kt).projection(1:2);
assert(preN{1}==preXgood);

Z = preXgood*U;
Ht = Z.A*At;
Kt = Z.b-Z.A*ft;
preXgood = Polyhedron(Ht, Kt).projection(1:2);
assert(preN{2}==preXgood);
assert(preX==preXgood);

end
