function test_polyunion_contains_08_pass
%
% polyhedra in V-rep

P1 = Polyhedron([-1; 1]);
P2 = Polyhedron([0; 2]);
P3 = Polyhedron([0.5; 3]);
U = PolyUnion([P1 P2 P3]);

assert(~P1.hasHRep);
assert(~P2.hasHRep);
assert(~P3.hasHRep);
assert(~U.Set(1).hasHRep);
assert(~U.Set(2).hasHRep);
assert(~U.Set(3).hasHRep);

% point outside, closest is P3
x = 10;
isin = U.contains(x);
assert(~isin);
assert(~U.Set(1).hasHRep); assert(~U.Set(2).hasHRep); assert(~U.Set(3).hasHRep);
[isin, inwhich] = U.contains(x);
assert(~isin);
assert(isempty(inwhich));
assert(~U.Set(1).hasHRep); assert(~U.Set(2).hasHRep); assert(~U.Set(3).hasHRep);
[isin, inwhich, closest] = U.contains(x);
assert(~isin);
assert(isempty(inwhich));
assert(closest==3);
assert(~U.Set(1).hasHRep); assert(~U.Set(2).hasHRep); assert(~U.Set(3).hasHRep);

% point in P2, P3
x = 1.5;
isin = U.contains(x);
assert(isin);
assert(~U.Set(1).hasHRep); assert(~U.Set(2).hasHRep); assert(~U.Set(3).hasHRep);
[isin, inwhich] = U.contains(x);
assert(isin);
assert(isequal(inwhich, [2 3]));
assert(~U.Set(1).hasHRep); assert(~U.Set(2).hasHRep); assert(~U.Set(3).hasHRep);
[isin, inwhich, closest] = U.contains(x);
assert(isin);
assert(isequal(inwhich, [2 3]));
assert(isempty(closest));
assert(~U.Set(1).hasHRep); assert(~U.Set(2).hasHRep); assert(~U.Set(3).hasHRep);

% point in P1
x = -0.5;
isin = U.contains(x);
assert(isin);
assert(~U.Set(1).hasHRep); assert(~U.Set(2).hasHRep); assert(~U.Set(3).hasHRep);
[isin, inwhich] = U.contains(x);
assert(isin);
assert(isequal(inwhich, 1));
assert(~U.Set(1).hasHRep); assert(~U.Set(2).hasHRep); assert(~U.Set(3).hasHRep);
[isin, inwhich, closest] = U.contains(x);
assert(isin);
assert(isequal(inwhich, 1));
assert(isempty(closest));
assert(~U.Set(1).hasHRep); assert(~U.Set(2).hasHRep); assert(~U.Set(3).hasHRep);

end
