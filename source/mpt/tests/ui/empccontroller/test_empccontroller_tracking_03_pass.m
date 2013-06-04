function test_empccontroller_tracking_03_pass
% LTI, output + input tracking

N = 2;
x0 = [1; 1];
uref = 0.5;
yref = 1;

L = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5], 'C', [1 0]);
L.x.with('terminalPenalty');
L.x.terminalPenalty = QuadFunction(1e-2*eye(2));
L.y.penalty = QuadFunction(1);
L.u.penalty = QuadFunction(1);
L.u.min = -1;
L.u.max = 1;
L.u.with('reference');
L.u.reference = 'free';
L.y.with('reference');
L.y.reference = 'free';

% on-line MPC
online = MPCController(L, N);
[u_on, feasible, openloop] = online.evaluate(x0, 'u.reference', uref, 'y.reference', yref);
Jgood = 1.23264105902116;
Jcomp = openloop.X(:, end)'*online.model.x.terminalPenalty.weight*openloop.X(:, end)+...
	online.model.y.penalty.weight*(openloop.Y-yref)*(openloop.Y-yref)'+...
	online.model.u.penalty.weight*(openloop.U-uref)*(openloop.U-uref)';
ugood = -0.27561501340568;
assert(feasible);
assert(abs(Jgood - Jcomp) <= 1e-8);
assert(abs(openloop.cost - Jgood) <= 1e-8);
assert(abs(u_on - ugood) <= 1e-8); 

% explicit MPC
explicit = online.toExplicit();
assert(explicit.nr==13); % 31 without bounding the reference

% make sure the ordering of parametric variables is correct (used to be a
% bug in Opt/private/setYalmipData and in YALMIP itself)
xc = explicit.partition.Set(1).chebyCenter.x;
% the third coordinate should be the input, which is bounded by +/- 1 (see
% explicit.xinitFormat for ordering);
assert((xc(3)<=1) && (xc(3)>=-1));

% bogus settings must alert the user
[~, msg] = run_in_caller('explicit.evaluate(x0)');
asserterrmsg(msg, 'Please provide initial value of "u.reference".');
[~, msg] = run_in_caller('explicit.evaluate(x0, ''u.reference'', uref)');
asserterrmsg(msg, 'Please provide initial value of "y.reference".');

% correct settings
[u, feasible, openloop] = explicit.evaluate(x0, 'u.reference', uref, 'y.reference', yref);
assert(feasible);
assert(abs(openloop.cost - Jgood) <= 1e-8); % leave as a strict test!
assert(abs(u - ugood) <= 1e-8); % leave as a strict test!

% swapping options must lead to the same result
[u, feasible, openloop] = explicit.evaluate(x0, 'y.reference', yref, 'u.reference', uref);
assert(feasible);
assert(abs(openloop.cost - Jgood) <= 1e-8);
assert(abs(u - ugood) <= 1e-8);

end
