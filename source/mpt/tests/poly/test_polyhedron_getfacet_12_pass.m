function test_polyhedron_getfacet_12_pass
%
% test extraction of multiple facets

P = Polyhedron('lb', [-1; -1], 'ub', [1; 1]).minHRep();
assert(size(P.H, 1)==4);

% row-based indices
idx = [1 3];
F = P.getFacet(idx);
assert(isa(F, 'Polyhedron'));
assert(numel(F)==2);
G1 = Polyhedron([-1 -1; -1 1]);
G2 = Polyhedron([1 1; 1 -1]);
assert(F(1)==G1);
assert(F(2)==G2);

% column-based indices
idx = [4; 1];
F = P.getFacet(idx);
assert(isa(F, 'Polyhedron'));
assert(numel(F)==2);
G2 = Polyhedron([-1 1; -1 -1]);
G1 = Polyhedron([1 1; -1 1]);
% ordering is important! we must get F(1)==G1, since idx=4 was the first
assert(F(1)==G1);
assert(F(2)==G2);

% identical indices should produce multiple facets
idx = 3*ones(1, 3);
F = P.getFacet(idx);
assert(numel(F)==numel(idx));
assert(F(1)==F(2));
assert(F(1)==F(3));
G = Polyhedron([1 1; 1 -1]);
for i = 1:numel(F)
	assert(F(i)==G);
end
