function test_polyhedron_getters_02_pass
% tests lazy getters with lower-dimensional polyhedra

% first an H-polyhedron
P = Polyhedron('He', [1 0]);
assert(~P.hasVRep);
assert(P.hasHRep);

P = Polyhedron('He', [1 0]);
assert(isempty(P.H));
assert(~P.hasVRep);

P = Polyhedron('He', [1 0]);
assert(isequal(P.He, [1 0]));
assert(~P.hasVRep);

P = Polyhedron('He', [1 0]);
assert(isempty(P.A));
assert(~P.hasVRep);

P = Polyhedron('He', [1 0]);
assert(isempty(P.b));
assert(~P.hasVRep);

P = Polyhedron('He', [1 0]);
assert(isequal(P.Ae, 1));
assert(~P.hasVRep);

P = Polyhedron('He', [1 0]);
assert(isequal(P.be, 0));
assert(~P.hasVRep);

P = Polyhedron('He', [1 0]);
assert(isequal(P.V, 0));
assert(P.hasVRep);

P = Polyhedron('He', [1 0 0]);
assert(isequal(P.R, [0 1]));
assert(P.hasVRep);

% now a V-polyhedron
P = Polyhedron([1 0; 0 1]);
assert(P.hasVRep);
assert(~P.hasHRep);

P = Polyhedron([1 0; 0 1]);
assert(isequal(P.V, [1 0; 0 1]));
assert(~P.hasHRep);

P = Polyhedron([1 0; 0 1]);
assert(isempty(P.R));
assert(~P.hasHRep);

P = Polyhedron([1 0; 0 1]);
assert(norm(sortrows(P.H) - [-1 -0 0;1 -0 1]) < 1e-8);
assert(P.hasHRep);

P = Polyhedron([1 0; 0 1]);
assert(norm(P.He - [-1 -1 -1]) < 1e-8);
assert(P.hasHRep);

P = Polyhedron([1 0; 0 1]);
assert(norm(sortrows(P.A) - [-1 -0;1 -0]) < 1e-8);
assert(P.hasHRep);

P = Polyhedron([1 0; 0 1]);
assert(norm(sortrows(P.b) - [0;1]) < 1e-8);
assert(P.hasHRep);

P = Polyhedron([1 0; 0 1]);
assert(norm(sortrows(P.Ae) - [-1 -1]) < 1e-8);
assert(P.hasHRep);

P = Polyhedron([1 0; 0 1]);
assert(norm(sortrows(P.be) - [-1]) < 1e-8);
assert(P.hasHRep);

end
