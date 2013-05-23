function test_mpccontroller_evaluate_05_pass
% MPCController/evaluate with wrong dimension of "x" should fail

% 1D
model = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
model.x.max = 5; model.x.min = -5;
model.u.max = 1; model.u.min = -1;
model.x.penalty = Penalty(1, 2);
model.u.penalty = Penalty(1, 2);
E = MPCController(model, 2);
[~, msg] = run_in_caller('u=E.evaluate([1; 1]);');
asserterrmsg(msg, 'The initial state must be a 1x1 vector.');

% 2D: point must be a column vector
model = LTISystem('A', eye(2), 'B', [1; 1]);
model.x.max = [5; 5]; model.x.min = [-5; -5];
model.u.max = 1; model.u.min = -1;
model.x.penalty = Penalty(eye(2), 2);
model.u.penalty = Penalty(1, 2);
E = MPCController(model, 2);
[~, msg] = run_in_caller('u=E.evaluate([1  1]);');
asserterrmsg(msg, 'The initial state must be a 2x1 vector.');
[~, msg] = run_in_caller('u=E.evaluate([1; 1; 1]);');
asserterrmsg(msg, 'The initial state must be a 2x1 vector.');

end
