function test_polyhedron_plus_16_pass
%
% sum of two arrays

A = Polyhedron(randn(10, 2)).minHRep();
B = Polyhedron(randn(10, 2)).minHRep();
C = Polyhedron(randn(10, 2)).minHRep();
D = Polyhedron(randn(10, 2)).minHRep();

S = [A B]+[C D];
% must get 4 elements
assert(numel(S)==4);
