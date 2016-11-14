function test_polyhedron_setdiff_25_pass
%
% set difference between empty sets
%

E = Polyhedron('H', zeros(0, 3));
F = Polyhedron('lb', [-1; -1], 'ub', [1; 1]).minHRep();

R = F\E;
assert(numel(R)==1);
assert(R==F);

R = E\F;
assert(isa(R, 'Polyhedron'));
assert(numel(R)==1);
assert(R.Dim==2);
assert(R.isEmptySet());

R = E\E;
assert(isa(R, 'Polyhedron'));
assert(numel(R)==1);
assert(R.Dim==2);
assert(R.isEmptySet());

R = F\F;
assert(isa(R, 'Polyhedron'));
assert(numel(R)==1);
assert(R.Dim==2);
assert(R.isEmptySet());

% also test empty arrays
E = E([]);
R = E\F;
assert(numel(R)==0);
assert(isa(R, 'Polyhedron'));

R = F\E;
assert(numel(R)==1);
assert(R==F);

R = E\E;
assert(numel(R)==0);
assert(isa(R, 'Polyhedron'));

end
