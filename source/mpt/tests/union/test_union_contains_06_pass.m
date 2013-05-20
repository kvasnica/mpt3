function test_union_contains_06_pass
%
% test empty arrays

P = Polyhedron;
U = Union;
U.add(P);
U = U([]); % empty array

[isin, inwhich, closest] = U.contains(1);
assert(isempty(isin));
assert(isempty(inwhich));
assert(isempty(closest));

end
