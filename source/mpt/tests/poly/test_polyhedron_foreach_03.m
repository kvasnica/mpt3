function test_polyhedron_foreach_03
%
% P.forEach() should repsect class of function's outputs

P1 = Polyhedron('lb', -1, 'ub', 1);
P2 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
P = [P1 P2];
a = P.forEach(@(x) size(x.H, 1)>2);
assert(isa(a, 'logical'));
assert(isequal(a, logical([0 1])));
