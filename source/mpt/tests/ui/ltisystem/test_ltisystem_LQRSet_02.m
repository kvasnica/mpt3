function test_ltisystem_LQRSet_02
% with u.setConstraint, x.setConstraint

model = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
model.x.min = [-5; -5];
model.x.max = [5; 5];
model.x.penalty = QuadFunction(eye(2));
model.u.penalty = QuadFunction(1);

model.u.min = -0.5;
model.u.max = 0.6;
S1 = model.LQRSet();
S1_exp = Polyhedron('H', [0.135017323795083 -0.280916176928742 0.6;-0.135017323795083 0.280916176928742 0.5;-0.00533643109831475 -0.529404762529573 0.6;0.00533643109831475 0.529404762529573 0.5;-0.519754007452359 -0.939957536022068 0.6;0.519754007452359 0.939957536022068 0.5]);
assert(S1==S1_exp);

model.u.min = -1;
model.u.max = 1;
if ~model.u.hasFilter('setConstraint')
    model.u.with('setConstraint');
end
model.u.setConstraint = Polyhedron('lb', -0.5, 'ub', 0.6);
S2 = model.LQRSet();
assert(S2==S1_exp);

end

