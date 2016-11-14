function test_polyhedron_getters_01_pass
% tests lazy getters with full-dimensional polyhedra

% first an H-polyhedron
P = Polyhedron('lb', -1, 'ub', 2);
assert(~P.hasVRep);
assert(P.hasHRep);

P = Polyhedron('lb', -1, 'ub', 2);
assert(isequal(P.H, [-1 1; 1 2]));
assert(~P.hasVRep);

P = Polyhedron('lb', -1, 'ub', 2);
assert(isequal(P.He, zeros(0, 2)));
assert(~P.hasVRep);

P = Polyhedron('lb', -1, 'ub', 2);
assert(isequal(P.A, [-1; 1]));
assert(~P.hasVRep);

P = Polyhedron('lb', -1, 'ub', 2);
assert(isequal(P.b, [1; 2]));
assert(~P.hasVRep);

P = Polyhedron('lb', -1, 'ub', 2);
assert(isempty(P.Ae));
assert(~P.hasVRep);

P = Polyhedron('lb', -1, 'ub', 2);
assert(isempty(P.be));
assert(~P.hasVRep);

P = Polyhedron('lb', -1, 'ub', 2);
assert(norm(sortrows(P.V) -[-1; 2]) < 1e-8);
assert(P.hasVRep);

P = Polyhedron('lb', -1, 'ub', 2);
assert(isempty(P.R));
assert(P.hasVRep);

% now a V-polyhedron
P = Polyhedron([1 1; 0 1; 1 0]);
assert(P.hasVRep);
assert(~P.hasHRep);

P = Polyhedron([1 1; 0 1; 1 0]);
assert(norm(sortrows(P.V) -[0 1; 1 0; 1 1]) < 1e-8);
assert(~P.hasHRep);

P = Polyhedron([1 1; 0 1; 1 0]);
assert(isempty(P.R));
assert(~P.hasHRep);

P = Polyhedron([1 1; 0 1; 1 0]);
P.computeHRep;
P.normalize();
assert(norm(sortrows(P.H) - [-sqrt(2)/2 -sqrt(2)/2 -sqrt(2)/2; 0 1 1; 1 0 1]) < 1e-8);
assert(P.hasHRep);

P = Polyhedron([1 1; 0 1; 1 0]);
assert(isequal(P.He, zeros(0, 3)));
assert(P.hasHRep);

P = Polyhedron([1 1; 0 1; 1 0]);
P.computeHRep;
P.normalize();
assert(norm(sortrows(P.A) - [-sqrt(2)/2 -sqrt(2)/2; 0 1; 1 0]) < 1e-8);
assert(P.hasHRep);

P = Polyhedron([1 1; 0 1; 1 0]);
P.computeHRep;
P.normalize();
assert(norm(sortrows(P.b) - [-sqrt(2)/2;1;1]) < 1e-8);
assert(P.hasHRep);

P = Polyhedron([1 1; 0 1; 1 0]);
assert(isempty(P.Ae));
assert(P.hasHRep);

P = Polyhedron([1 1; 0 1; 1 0]);
assert(isempty(P.be));
assert(P.hasHRep);



end
