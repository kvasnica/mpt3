function test_polyunion_compare_02_pass

P0 = Polyhedron.unitBox(1);
P0.addFunction(AffFunction(0, 0), 'x');
U0 = PolyUnion(P0);
P1 = Polyhedron.unitBox(1);
P1.addFunction(AffFunction(0, 1), 'x');
U1 = PolyUnion(P1);
P2 = Polyhedron.unitBox(1);
P2.addFunction(AffFunction(2, 0), 'x');
U2 = PolyUnion(P2);

% U0==U0
result = U0.compare(U0);
assert(result==0);

% U1==U1
result = U1.compare(U1);
assert(result==0);

% U1>=U0
result = U1.compare(U0);
assert(result==1);

% U0<=U1
result = U0.compare(U1);
assert(result==2);

% U2<=U0, U2>=U0
result = U0.compare(U2);
assert(result==3);

% U2<=U0, U2>=U0
result = U2.compare(U0);
assert(result==3);

end
