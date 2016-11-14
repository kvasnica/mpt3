function test_polyhedron_chebyCenter_10_pass
% cheybCenter of an empty polyhedron

x = chebyCenter(Polyhedron);
assert(isempty(x.x));
assert(x.r==-Inf);
