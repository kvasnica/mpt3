function test_polyhedron_distance_15_pass
% distance from an empty set is Inf (issue #111)

P = Polyhedron.emptySet(2);
R = Polyhedron.unitBox(2);

% distance from an empty set is Inf
d = P.distance(R);
assert(d.dist==Inf);
d = R.distance(P);
assert(d.dist==Inf);
d = P.distance(P);
assert(d.dist==Inf);

% distance of a point from an empty set is Inf
Q = [0; 0];
d = P.distance(Q);
assert(d.dist==Inf);

end
