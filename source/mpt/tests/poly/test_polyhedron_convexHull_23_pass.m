function test_polyhedron_convexHull_23_pass
% tests convexHull for arrays

P1 = Polyhedron([eye(2); -eye(2)], [0; 0; 1; 1]);
P2 = Polyhedron([eye(2); -eye(2)], [1; 1; 0; 0]);
P = [P1 P2];

% no redundancy elimination by default
assert(~P1.irredundantHRep);
assert(~P2.irredundantHRep);
assert(~P(1).irredundantHRep);
assert(~P(2).irredundantHRep);

% request redundancy elimination
P.minHRep();
assert(length(P)==2);
assert(P1.irredundantHRep);
assert(P2.irredundantHRep);
assert(P(1).irredundantHRep);
assert(P(2).irredundantHRep);

end
