function test_mpccontrolle_soft_03_pass
% default setting of softMin/softMax filters must work

A = [1 1; 0 1];
B = [1; 0.5];
lti = LTISystem('A', A, 'B', B);

lti.x.min = [-5; -5];
lti.x.max = [5; 5];

lti.x.with('softMax');
lti.x.with('softMin');

% Add constraints on predicted control inputs
lti.u.min = -1;
lti.u.max = 1;

% Use quadratic state penalty with identity weighting matrix
lti.x.penalty = Penalty(0.1*eye(2), 2);
lti.u.penalty = Penalty(1, 2);

% Define an MPC controller using "lti" as the prediction model
ctrl = MPCController(lti, 10);

u = ctrl.evaluate([5; 0.1])
ugood = -1;
assert(norm(u-ugood)<1e-8);

end
