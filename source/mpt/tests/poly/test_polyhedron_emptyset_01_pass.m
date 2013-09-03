function test_polyhedron_emptyset_01_pass
% tests Polyhedron.emptySet(dim)

E = Polyhedron.emptySet(2);
assert(E.Dim==2);
assert(E.Internal.Empty==true);
assert(all(E.Internal.lb==Inf));
assert(all(E.Internal.ub==-Inf));
assert(E.isEmptySet);
assert(~E.isFullDim);
assert(isempty(E.H));
assert(isempty(E.He));
assert(isempty(E.R));
assert(isempty(E.V));

end
