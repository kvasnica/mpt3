function test_mpccontroller_tracking_02_pass
% LTI, input tracking

N = 20;
x0 = [1; 1];
uref = 0.5;

L = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
L.x.penalty = QuadFunction(1e-2*eye(2));
L.u.penalty = QuadFunction(100);
L.u.min = -1;
L.u.max = 1;
L.u.with('reference');
L.u.reference = 'free';
ctrl = MPCController(L, N);

% bogus settings must alert the user
[~, msg] = run_in_caller('ctrl.evaluate(x0)');
asserterrmsg(msg, 'Please provide initial value of "u.reference".');
[~, msg] = run_in_caller('ctrl.evaluate(x0, ''x.reference'', 1)');
asserterrmsg(msg, 'Please provide initial value of "u.reference".');
[~, msg] = run_in_caller('ctrl.evaluate(x0, ''u.reference'', [1; 2])');
asserterrmsg(msg, '"u.reference" must be a 1x1 vector.');

% correct settings
[u, feasible, openloop] = ctrl.evaluate(x0, 'u.reference', uref);
Jcomp = sum(diag(ctrl.model.x.penalty.weight*openloop.X(:, 1:end-1)*openloop.X(:, 1:end-1)'))+...
	ctrl.model.u.penalty.weight*(openloop.U-uref)*(openloop.U-uref)';
% compute the cost manually:
Jgood = 195.915561546513;
ugood = 0.186037667506576;
assert(feasible);
assert(abs(Jgood-Jcomp) <= 1e-8);
assert(abs(openloop.cost - Jgood) <= 1e-8);
assertwarning(abs(u - ugood) <= 1e-8);

% changing the reference must work
uref = -1;
[u, feasible, openloop] = ctrl.evaluate(x0, 'u.reference', uref);
% compute the cost manually:
Jcomp = sum(diag(ctrl.model.x.penalty.weight*openloop.X(:, 1:end-1)*openloop.X(:, 1:end-1)'))+...
	ctrl.model.u.penalty.weight*(openloop.U-uref)*(openloop.U-uref)';
Jgood = 218.418966173325;
assert(feasible);
assert(abs(Jgood-Jcomp) <= 1e-8);
assert(abs(openloop.cost - Jgood) <= 1e-8);

% updating constraints must take effect
ctrl.model.u.min = -0.6;
uref = -1; % reference must be inside of umin/umax constraints
[u, feasible, openloop] = ctrl.evaluate(x0, 'u.reference', uref);
assert(~feasible);
uref = -0.6; % correct reference
[u, feasible, openloop] = ctrl.evaluate(x0, 'u.reference', uref);
ugood = -0.45342181194255;
% compute the cost manually:
Jcomp = sum(diag(ctrl.model.x.penalty.weight*openloop.X(:, 1:end-1)*openloop.X(:, 1:end-1)'))+...
	ctrl.model.u.penalty.weight*(openloop.U-uref)*(openloop.U-uref)';
Jgood = 51.8430942909014;
assert(feasible);
assert(abs(Jgood-Jcomp) <= 1e-8);
assert(abs(openloop.cost - Jgood) <= 1e-8);
assert(abs(u-ugood) <= 1e-8);

end
