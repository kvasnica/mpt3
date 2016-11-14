function test_polyunion_le_01_pass
% containement of empty unions

Pe = Polyhedron([1; -1], [0; -1]);
Pn = Polyhedron('lb', -1, 'ub', 1);
E1 = PolyUnion;
E2 = PolyUnion(Pe);
E3 = PolyUnion([Pe Pe]);
N1 = PolyUnion(Pn);

% empty union is always contained
assert(E1<=E2);
assert(E1<=E3);
assert(E2<=E1);
assert(E2<=E3);
assert(E3<=E1);
assert(E3<=E2);
assert(E1<=N1);
assert(E2<=N1);
assert(E3<=N1);
assert(N1>=E1);
assert(N1>=E2);
assert(N1>=E3);

% non-empty union cannot be contained in an empty union
assert(~(N1<=E1));
assert(~(N1<=E2));
assert(~(N1<=E2));
assert(~(E1>=N1));
assert(~(E2>=N1));
assert(~(E3>=N1));

end
