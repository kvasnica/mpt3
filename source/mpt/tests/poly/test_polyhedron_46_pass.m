function test_polyhedron_46_pass
% V-rep of R^n should be quickly returned by Polyhedron/computeVRep

P = Polyhedron([0 0], 1);
assert(isequal(P.V, [0 0]));
assert(isequal(P.R, [eye(2); -eye(2)]));

P = Polyhedron.fullSpace(3);
assert(isequal(P.V, [0 0 0]));
assert(isequal(P.R, [eye(3); -eye(3)]));

end
