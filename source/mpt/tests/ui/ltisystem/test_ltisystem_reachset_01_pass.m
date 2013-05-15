function test_ltisystem_backreach_01_pass
% LTISystem/reachableSet with direction=backwards

% autonomous system, N=1
sys = LTISystem('A', [1 1; 0 1]);
X = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
preX = sys.reachableSet('X', X, 'direction', 'backward');
assert(length(preX)==1);
assert(isa(preX, 'Polyhedron'));
Ht = X.A*sys.A;
Kt = X.b;
preXgood = Polyhedron(Ht, Kt);
assert(preX==preXgood);
Hgood = [-1 -1;0 -1;1 1;0 1];
Kgood = ones(4, 1);
assert(Polyhedron(Hgood, Kgood)==preX);

% autonomous system, N=1
sys = LTISystem('A', [1 1; 0 1]);
X = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
preX = sys.reachableSet('X', X, 'N', 1, 'direction', 'back');
assert(length(preX)==1);
assert(isa(preX, 'Polyhedron'));
Ht = X.A*sys.A;
Kt = X.b;
preXgood = Polyhedron(Ht, Kt);
assert(preX==preXgood);

% autonomous system, N=2
sys = LTISystem('A', [1 1; 0 1]);
X = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
[preX, preN] = sys.reachableSet('X', X, 'N', 2, 'direction', 'b');
assert(isa(preX, 'Polyhedron'));
assert(length(preX)==1);
assert(iscell(preN));
assert(length(preN)==2);
assert(isa(preN{1}, 'Polyhedron'));
assert(isa(preN{2}, 'Polyhedron'));
Ht = X.A*sys.A;
Kt = X.b;
preX1good = Polyhedron(Ht, Kt);
Ht = preX1good.A*sys.A;
Kt = preX1good.b;
preX2good = Polyhedron(Ht, Kt);
assert(preX==preX2good);
assert(preN{1}==preX1good);
assert(preN{2}==preX2good);

end
