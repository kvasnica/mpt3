function test_ltisystem_backreach_02_pass
% LTISystem/reachableSet with autonomous system w/ affine term (backwards)

% autonomous system, N=1
sys = LTISystem('A', [1 1; 0 1], 'f', [1; 2]);
X = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
preX = sys.reachableSet('X', X, 'direction', 'backwards');
assert(length(preX)==1);
assert(isa(preX, 'Polyhedron'));
Ht = X.A*sys.A;
Kt = X.b-X.A*sys.f;
preXgood = Polyhedron(Ht, Kt);
assert(preX==preXgood);
Hgood = [-1 -1;0 -1;1 1;0 1];
Kgood = [2; 3; 0; -1];
assert(Polyhedron(Hgood, Kgood)==preX);

% autonomous system, N=1
sys = LTISystem('A', [1 1; 0 1], 'f', [1; 2]);
X = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
preX = sys.reachableSet('X', X, 'N', 1, 'direction', 'back');
assert(length(preX)==1);
assert(isa(preX, 'Polyhedron'));
Ht = X.A*sys.A;
Kt = X.b-X.A*sys.f;
preXgood = Polyhedron(Ht, Kt);
assert(preX==preXgood);
Hgood = [-1 -1;0 -1;1 1;0 1];
Kgood = [2; 3; 0; -1];
assert(Polyhedron(Hgood, Kgood)==preX);

% autonomous system, N=2
sys = LTISystem('A', [1 1; 0 1], 'f', [1; 2]);
X = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
[preX, preN] = sys.reachableSet('X', X, 'N', 2, 'direction', 'b');
assert(isa(preX, 'Polyhedron'));
assert(length(preX)==1);
assert(iscell(preN));
assert(length(preN)==2);
assert(isa(preN{1}, 'Polyhedron'));
assert(isa(preN{2}, 'Polyhedron'));
Ht = X.A*sys.A;
Kt = X.b-X.A*sys.f;
preX1good = Polyhedron(Ht, Kt);
Ht = preX1good.A*sys.A;
Kt = preX1good.b-preX1good.A*sys.f;
preX2good = Polyhedron(Ht, Kt);
assert(preX==preX2good);
assert(preN{1}==preX1good);
assert(preN{2}==preX2good);

end
