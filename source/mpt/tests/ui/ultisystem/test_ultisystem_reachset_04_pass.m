function test_ultisystem_reachset_04_pass
% backward reachable set wrong for a 1D system

a = 2;
Hx = [1;-1];
hx = [1;1];
X = Polyhedron(Hx, hx);
sys1 = ULTISystem('A', a);
R1 = sys1.reachableSet('X', X, 'direction', 'backward');
R1_exp = X.invAffineMap(a);
assert(R1==R1_exp);

% LTISystem/reachableSet must give the same result
sys2 = LTISystem('A', a);
Q1 = sys2.reachableSet('X', X, 'direction', 'backward');
assert(Q1==R1);

end
