function test_empccontroller_evaluate_06_pass
%
% test single optimizer with cost-based tiebreaking

P1 = Polyhedron('lb', 0, 'ub', 1.5);
P2 = Polyhedron('lb', 1, 'ub', 2);
u1 = 3;
u2 = 4;
J1 = 2;
J2 = 1;
primal1 = AffFunction(0, u1);
primal2 = AffFunction(0, u2);
obj1 = AffFunction(0, J1);
obj2 = AffFunction(0, J2);
P1.addFunction(primal1, 'primal');
P1.addFunction(obj1, 'obj');
P2.addFunction(primal2, 'primal');
P2.addFunction(obj2, 'obj');
optimizer = PolyUnion([P1 P2]);
E = EMPCController(optimizer);
E.N = 1;
E.nu = 1;

% point outside
x = -10;
[a, feas, c] = E.evaluate(x);
assert(~feas);
assert(isscalar(a));
assert(isnan(a));
assert(c.cost==Inf);
assert(isempty(c.partition));
assert(isempty(c.region));

% point in P1
x = 0.1;
[a, feas, c] = E.evaluate(x);
assert(feas);
assert(isequal(a, u1));
assert(isequal(c.cost, J1));
assert(c.partition==1);
assert(c.region==1);

% point in P2
x = 1.6;
[a, feas, c] = E.evaluate(x);
assert(feas);
assert(isequal(a, u2));
assert(isequal(c.cost, J2));
assert(c.partition==1);
assert(c.region==2);

% point in P1 and P2, P2 should win on the cost tiebreak
x = 1.1;
[a, feas, c] = E.evaluate(x);
assert(feas);
assert(isequal(a, u2));
assert(isequal(c.cost, J2));
assert(c.partition==1);
assert(c.region==2);

end
