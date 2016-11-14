function test_polyhedron_fullspace_02_pass
% R^0 is an empty set, hence bounded and not fully dimensional

P = Polyhedron.fullSpace(0);
assert(P.Internal.Empty);
assert(P.Internal.Bounded);
assert(~P.Internal.FullDim);
assert(~P.isFullDim());
assert(P.isBounded());
assert(P.isEmptySet());

end
