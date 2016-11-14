function test_polyhedron_setdiff_22_pass
%
% set difference between full and lower dimensional polytopes (one split is
% not fully dimensional)
%

% cube \ facet = cube
P1 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]).minHRep();
V2 = [1 -1; 1 1];
P2 = Polyhedron(V2).minHRep();
R = P1\P2;
assert(numel(R)==1);
assert(R==P1);

% cube \ subset of a facet = cube
P1 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]).minHRep();
V2 = [1 -0.5; 1 0.5];
P2 = Polyhedron(V2).minHRep();
R = P1\P2;
assert(numel(R)==1);
assert(R==P1);

% cube \ superset of a facet = cube
P1 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]).minHRep();
V2 = [1 -2; 1 2];
P2 = Polyhedron(V2).minHRep();
R = P1\P2;
assert(numel(R)==1);
assert(R==P1);

% cube \ valid inequality = cube
P1 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]).minHRep();
V2 = [2 -1; 2 1];
P2 = Polyhedron(V2).minHRep();
R = P1\P2;
assert(numel(R)==1);
assert(R==P1);

end
