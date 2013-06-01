function test_empccontroller_clicksim_02_pass
% LTI, state tracking

N = 2;
xref = [3; 0];
x0 = [4; 1];

L = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
L.x.penalty = QuadFunction(eye(2));
L.u.penalty = QuadFunction(1);
L.u.min = -1;
L.u.max = 1;
L.x.min = [-5; -5];
L.x.max = [5; 5];
L.x.with('reference');
L.x.reference = 'free';
ctrl = EMPCController(L, N);
assert(ctrl.nr==17);

% must ask for x.reference
[~, msg] = run_in_caller('d = ctrl.clicksim(''x0'', x0)');
asserterrmsg(msg, 'Please provide initial value of "x.reference".');

% must work
d = ctrl.clicksim('x0', x0, 'x.reference', xref);
close
Jgood = 8.01874999999998;
assert(abs(sum(d.cost) - Jgood) <= 1e-8);
assert(isequal(d.X(:, 1), x0));
assert(norm(d.X(:, end)-xref) <= 1e-4);

end
