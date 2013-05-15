function test_empccontroller_evaluate_01_fail
% EMPCController/evaluate with wrong dimension of "x" should fail

model = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
model.x.max = 5; model.x.min = -5;
model.u.max = 1; model.u.min = -1;
model.x.penalty = Penalty(1, 2);
model.u.penalty = Penalty(1, 2);
E = EMPCController(model, 2);

E.evaluate([1; 1]);

end
