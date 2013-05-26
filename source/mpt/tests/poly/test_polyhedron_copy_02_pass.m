function test_polyhedron_copy_02_pass
% copying of a polyhedron array without functions

% empty array
P = Polyhedron;
P = P([]);
assert(numel(P)==0);
assert(isa(P, 'Polyhedron'));
Q = P.copy();
assert(numel(Q)==0);
assert(isa(Q, 'Polyhedron'));

% two polyhedra
P1 = Polyhedron('lb', -1, 'ub', 1);
P2 = Polyhedron([1; -1]);
P = [P1 P2];
assert(~P(1).hasVRep);
assert(~P(2).hasHRep);
assert(P(1).hasHRep);
assert(P(2).hasVRep);

Q = P.copy();
assert(isa(Q, 'Polyhedron'));
assert(numel(Q)==numel(P));

% now manipulate P, Q should stay unchanged
P.minHRep();
assert(~Q(1).hasVRep);
assert(~Q(2).hasHRep);
assert(Q(1).hasHRep);
assert(Q(2).hasVRep);

end
