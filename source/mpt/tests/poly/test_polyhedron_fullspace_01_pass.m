function test_polyhedron_fullspace_01_pass
% tests Polyhedron.fullSpace(d) (issue #92)

R = Polyhedron.fullSpace(2);
assert(R.Dim==2);
assert(R.hasHRep);
assert(R.irredundantHRep);
assert(R.isFullDim);
assert(~R.isEmptySet);
assert(~R.isBounded);
assert(isequal(R.H, [0 0 1]));
assert(isempty(R.He));

end
