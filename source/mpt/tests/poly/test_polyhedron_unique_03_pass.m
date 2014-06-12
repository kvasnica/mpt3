function test_polyhedron_unique_03_pass
% tests Polyhedron/unique()

P1 = Polyhedron('lb', -1, 'ub', 1);
P2 = Polyhedron('lb', -2, 'ub', 2);
P3 = Polyhedron('lb', -3, 'ub', 3);
Q = [P3 P1 P1 P2 P1 P1 P2 P3 P1 P3];
[a, b] = Q.unique();
assert(numel(a)==3);
assert(a(1)==P3);
assert(a(2)==P1);
assert(a(3)==P2);
assert(isequal(b, [1; 2; 4]));

end
