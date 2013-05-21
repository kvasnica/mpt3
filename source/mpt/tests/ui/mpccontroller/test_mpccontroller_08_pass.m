function test_mpccontroller_08_pass
% changing the penalty must make an effect

A = [1 1; 0 1];
B = [1; 0.5];
lti = LTISystem('A', A, 'B', B, 'C', [1 0]);
lti.x.min = [-5; -5];
lti.x.max = [5; 5];
lti.u.min = -1;
lti.u.max = 1;
lti.x.penalty = Penalty(0.1*eye(2), 2);
lti.u.penalty = Penalty(1, 2);
ctrl = MPCController(lti, 4);
[~, ~, c] = ctrl.evaluate([5; 1]);
Jgood = 10.995;
assert(abs(c.cost-Jgood) < 1e-8);

% now change the penalty
ctrl.model.u.penalty.Q = 100;
[~, ~, c] = ctrl.evaluate([5; 1]);
Jgood = 142.9453;
assert(abs(c.cost-Jgood) < 1e-8);

end
