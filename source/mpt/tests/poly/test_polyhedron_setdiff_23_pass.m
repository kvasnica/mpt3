function test_polyhedron_setdiff_23_pass
%
% set difference between full and lower dimensional polytopes (two full
% dimensional splits)
%

% unless we support open polyhedra, R==P1

% D1 = Polyhedron('lb', [-1; -1], 'ub', [0.5; 1]);
% D2 = Polyhedron('lb', [0.5; -1], 'ub', [1; 1]);

P1 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]).minHRep();
V2 = [0.5 -1; 0.5 1];
P2 = Polyhedron(V2).minHRep();
R = P1\P2;
assert(numel(R)==1);
assert(R==P1);

P1 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]).minHRep();
V2 = [0.5 -0.5; 0.5 0.5];
P2 = Polyhedron(V2).minHRep();
R = P1\P2;
assert(numel(R)==1);
assert(R==P1);

P1 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]).minHRep();
V2 = [0.5 -2; 0.5 2];
P2 = Polyhedron(V2).minHRep();
R = P1\P2;
assert(numel(R)==1);
assert(R==P1);

end
