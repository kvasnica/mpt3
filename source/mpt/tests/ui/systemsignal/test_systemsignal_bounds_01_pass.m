function test_systemsignal_bounds_01_pass
% boundsToPolyhedron() should include bounds from signal.setConstraint

% first without setConstraint
s = SystemSignal(2);
s.min = [-1; -2];
s.max = [3; 4];
P = Polyhedron('lb', [-1; -2], 'ub', [3; 4]);
assert(s.boundsToPolyhedron()==P);

% and now with it -- the result must be the intersection of lower/upper
% bounds with the set
Q = Polyhedron('lb', [-10; -1], 'ub', [2.5; 4.5]);
s.with('setConstraint');
s.setConstraint = Q;
Expected = Q & P;
assert(s.boundsToPolyhedron()==Expected);

Q = Polyhedron(randn(10, 2)*2);
s.with('setConstraint');
s.setConstraint = Q;
Expected = Q & P;
assert(s.boundsToPolyhedron()==Expected);

end
