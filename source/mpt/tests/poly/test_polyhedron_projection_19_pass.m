function test_polyhedron_projection_19_pass
% projection of R^n

R = Polyhedron.fullSpace(3);
P = R.projection(1:2);
expected = Polyhedron.fullSpace(2);
assert(P.isFullSpace());
assert(P==expected);

R = Polyhedron([0 1], 1);
P = R.projection(1); % R^1 here
expected = Polyhedron.fullSpace(1);
assert(P.isFullSpace());
assert(P==expected);

P = R.projection(2); % just the set { x(2) | x(2)<=1 } here
expected = Polyhedron(1, 1);
assert(~P.isEmptySet);
assert(P.isFullDim);
assert(P==expected);
assert(P.contains(1));
assert(~P.contains(1+1e-5));
assert(P.contains(1-1e-5));

end
