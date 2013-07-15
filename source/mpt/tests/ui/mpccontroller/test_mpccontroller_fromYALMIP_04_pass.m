function test_mpccontroller_fromYALMIP_04_pass
% must allow to introduce new variables

model = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
model.u.min = -1;
model.u.max = 1;
model.x.max = [5; 5];
model.x.min = [-5; -5];
model.u.penalty = QuadFunction(1);
model.x.penalty = QuadFunction(eye(2));
mpc = MPCController(model, 5);
Y = mpc.toYALMIP();

% obstacle avoidance:
Pavoid = Polyhedron('lb', [-1; -1], 'ub', [-0.5; -0.5]);
d = binvar(1, 1);
Y.constraints = Y.constraints + [implies(ismember(Y.variables.x(:, 1), Pavoid), d)];
Y.objective = Y.objective + 1000*d;

% updated controller
mpc.fromYALMIP(Y);

% point inside of Pavoid => 1000 must be added to the cost
x0 = [-0.75; -0.75];
[~, ~, ol] = mpc.evaluate(x0);
Jgood = 1002.7921249295;
assert(abs(ol.cost - Jgood) <= 1e-4);

% point outside of Pavoid => cost must be small
x0 = [1; 1];
[~, ~, ol] = mpc.evaluate(x0);
Jgood = 5.6684997179921;
assert(abs(ol.cost - Jgood) <= 1e-4);

end
