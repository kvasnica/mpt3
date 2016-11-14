function test_polyhedron_copy_01_pass
% copying of a single polyhedron without functions

% empty polyhedron
P = Polyhedron;
Q = P.copy();
assert(Q.Dim==0);
assert(~Q.hasHRep);
P.minHRep(); % this should leave Q intact
assert(P.hasHRep);
assert(~Q.hasHRep);

% H-rep
P = Polyhedron('lb', -1, 'ub', 1);
Hp = P.H;
assert(~P.hasVRep);
Q = P.copy();
assert(~Q.hasVRep);
Hq = Q.H;
assert(isequal(Hp, Hq));

% now enumerate vertices of P, Q should stay without the V-rep
V = P.V;
assert(P.hasVRep);
assert(~Q.hasVRep);

% V-rep
P = Polyhedron([1; -1]);
Vp = P.V;
assert(~P.hasHRep);
Q = P.copy();
assert(~Q.hasHRep);
Vq = Q.V;
assert(isequal(Vp, Vq));

% now convert P to H-rep, Q should stay without the H-rep
P.minHRep();
assert(P.hasHRep);
assert(~Q.hasHRep);

% changing a copy must leave the original intact
P = Polyhedron('lb', -1, 'ub', 1);
Q = P.copy();
assert(~P.hasVRep);
assert(~Q.hasVRep);
V = Q.V;
assert(Q.hasVRep);
assert(~P.hasVRep);

end
