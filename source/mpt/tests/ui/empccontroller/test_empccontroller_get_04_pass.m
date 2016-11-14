function test_empccontroller_get_04_pass
% tests that "cost", "feedback" and "partition" are updated once
% "optimizer" is changed

P = Polyhedron('lb', -1, 'ub', 1);
P.addFunction(AffFunction(1, 1), 'primal');
P.addFunction(AffFunction(2, 2), 'obj');
U1 = PolyUnion(P);
P2 = Polyhedron('lb', 10, 'ub', 11);
P2.addFunction(AffFunction(3, 3), 'primal');
P2.addFunction(AffFunction(4, 4), 'obj');
U2 = PolyUnion([P P2]);

E = EMPCController(U1);
E.nx = 1;
E.nu = 1;
E.N = 1;

% original polyunion
assert(E.nr==1);
c = E.cost;
assert(isa(c, 'PolyUnion'));
assert(c.hasFunction('obj'));
assert(~c.hasFunction('primal'));
assert(c.Num==1);
c = E.feedback;
assert(isa(c, 'PolyUnion'));
assert(~c.hasFunction('obj'));
assert(c.hasFunction('primal'));
assert(c.Num==1);
c = E.partition;
assert(~c.hasFunction('obj'));
assert(~c.hasFunction('primal'));
assert(c.Num==1);

% now modify the optimizer, the other properties must be updated
E.optimizer = U2;
assert(E.nr==2);
c = E.cost;
assert(isa(c, 'PolyUnion'));
assert(c.hasFunction('obj'));
assert(~c.hasFunction('primal'));
assert(c.Num==2);
c = E.feedback;
assert(isa(c, 'PolyUnion'));
assert(~c.hasFunction('obj'));
assert(c.hasFunction('primal'));
assert(c.Num==2);
c = E.partition;
assert(~c.hasFunction('obj'));
assert(~c.hasFunction('primal'));
assert(c.Num==2);

end
