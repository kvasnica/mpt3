function test_polyhedron_getfacet_09_pass
%
% P.getFacet() should return all facets

P = Polyhedron('lb', [-1; -1], 'ub', [1; 1]).minHRep();
assert(size(P.H, 1)==4);
F = P.getFacet();
assert(isa(F, 'Polyhedron'));
assert(numel(F)==4);
G1 = Polyhedron([-1 -1; -1 1]);
G2 = Polyhedron([-1 1; 1 1]);
G3 = Polyhedron([1 1; 1 -1]);
G4 = Polyhedron([1 -1; -1 -1]);
assert([G1 G2 G3 G4]==F);

end
