function test_polyunion_10_pass
% tests the Union.Domain getter

% union without domain
P1 = Polyhedron('lb', -1, 'ub', 1);
P2 = Polyhedron('lb', 1, 'ub', 2);
U = PolyUnion([P1 P2]);
assert(isa(U.Domain, 'Polyhedron'));
assert(numel(U.Domain)==2);
assert(U.Domain==[P1 P2]);

% union with domain
D = Polyhedron('lb', -1, 'ub', 2);
U = PolyUnion('Set', [P1 P2], 'Domain', D);
assert(isa(U.Domain, 'Polyhedron'));
assert(numel(U.Domain)==1);
assert(U.Domain==D);

% empty domain
E = Polyhedron([1; -1], [-1; 0]);
U = PolyUnion('Set', [P1 P2], 'Domain', E);
assert(isa(U.Domain, 'Polyhedron'));
assert(numel(U.Domain)==2); % since the domain is empty, returns the set
assert(U.Domain==[P1 P2]);

% empty domain and empty set
U = PolyUnion('Set', E, 'Domain', E);
assert(isempty(U.Domain));

% non-empty domain and empty set
U = PolyUnion('Set', E, 'Domain', P1);
assert(isempty(U.Domain));

% wrong dimension of the domain
D = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
[~, msg] = run_in_caller('U = PolyUnion(''Set'', P1, ''Domain'', D)');
asserterrmsg(msg, 'The domain must be a 1D polyhedron.');

end
