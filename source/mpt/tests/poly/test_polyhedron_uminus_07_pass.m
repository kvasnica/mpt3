function test_polyhedron_uminus_07_pass
% do not compute V/H rep if not contained

P = Polyhedron('lb', -1, 'ub', 1);
assert(~P.hasVRep);
assert(P.hasHRep);
Pm = -P;
assert(~Pm.hasVRep);
assert(~P.hasVRep);
assert(Pm.hasHRep);

P = Polyhedron([1; -1]);
assert(~P.hasHRep);
assert(P.hasVRep);
Pm = -P;
assert(Pm.hasVRep);
assert(P.hasVRep);
assert(~Pm.hasHRep);
assert(~P.hasHRep);

P = Polyhedron([1; -1]);
P.minHRep();
assert(P.hasHRep);
assert(P.hasVRep);
Pm = -P;
assert(Pm.hasVRep);
assert(Pm.hasHRep);

end
