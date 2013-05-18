function test_empccontroller_evaluate_07_pass
%
% test multiple optimizer with cost-based tiebreaking

% 3 overlapping optimizers
P1 = Polyhedron('lb', 0, 'ub', 1.5);
P2 = Polyhedron('lb', 0.1, 'ub', 2);
u1_1 = 11;
u1_2 = 12;
J1_1 = 2;
J1_2 = 1;
primal1 = AffFunction(0, u1_1);
primal2 = AffFunction(0, u1_2);
obj1 = AffFunction(0, J1_1);
obj2 = AffFunction(0, J1_2);
P1.addFunction(primal1, 'primal');
P1.addFunction(obj1, 'obj');
P2.addFunction(primal2, 'primal');
P2.addFunction(obj2, 'obj');
opt1 = PolyUnion([P1 P2]);

P = Polyhedron('lb', 0.2, 'ub', 1.2);
u2_1 = 21;
J2_1 = -1;
primal1 = AffFunction(0, u2_1);
obj1 = AffFunction(0, J2_1);
P.addFunction(primal1, 'primal');
P.addFunction(obj1, 'obj');
opt2 = PolyUnion(P);

P1 = Polyhedron('lb', 1, 'ub', 1.5);
P2 = Polyhedron('lb', 1, 'ub', 2);
u3_1 = 31;
u3_2 = 32;
J3_1 = -1;
J3_2 = 0;
primal1 = AffFunction(0, u3_1);
primal2 = AffFunction(0, u3_2);
obj1 = AffFunction(0, J3_1);
obj2 = AffFunction(0, J3_2);
P1.addFunction(primal1, 'primal');
P1.addFunction(obj1, 'obj');
P2.addFunction(primal2, 'primal');
P2.addFunction(obj2, 'obj');
opt3 = PolyUnion([P1 P2]);

E = EMPCController([opt1 opt2 opt3]);
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

% point in P1 of opt1
x = 0.05;
[a, feas, c] = E.evaluate(x);
assert(feas);
assert(isequal(a, u1_1));
assert(isequal(c.cost, J1_1));
assert(c.partition==1);
assert(c.region==1);

% point in P1 and P2 of opt1, P2 wins on tiebreak
x = 0.1;
[a, feas, c] = E.evaluate(x);
assert(feas);
assert(isequal(a, u1_2));
assert(isequal(c.cost, J1_2));
assert(c.partition==1);
assert(c.region==2);

% point in P2 of opt1
x = 0.15;
[a, feas, c] = E.evaluate(x);
assert(feas);
assert(isequal(a, u1_2));
assert(isequal(c.cost, J1_2));
assert(c.partition==1);
assert(c.region==2);

% point in P2 of opt1 and in P1 of opt2, opt2 wins on tiebreak
x = 0.25;
[a, feas, c] = E.evaluate(x);
assert(feas);
assert(isequal(a, u2_1));
assert(isequal(c.cost, J2_1));
assert(c.partition==2);
assert(c.region==1);

% point in all, P1 of opt2 should witn
x = 1;
[a, feas, c] = E.evaluate(x);
assert(feas);
assert(isequal(a, u2_1));
assert(isequal(c.cost, J2_1));
assert(c.partition==2);
assert(c.region==1);

% point in all of opt1 and all of opt3, P1 of opt3 should win
x = 1.5;
[a, feas, c] = E.evaluate(x);
assert(feas);
assert(isequal(a, u3_1));
assert(isequal(c.cost, J3_1));
assert(c.partition==3);
assert(c.region==1);

% point P2/opt2, P2/opt3, opt3 should win
x = 2;
[a, feas, c] = E.evaluate(x);
assert(feas);
assert(isequal(a, u3_2));
assert(isequal(c.cost, J3_2));
assert(c.partition==3);
assert(c.region==2);

end
