function test_mpccontroller_tracking_06_pass
% reference tracking with trajectory preview (1 output)

ny = 1;
L = LTISystem('A', [1 1; 0.1 1], 'B', [1; 0.5], 'C', eye(ny));
L.u.penalty = QuadFunction(1);
L.u.min = -5;
L.u.max = 5;
L.y.penalty = QuadFunction(eye(ny));
L.y.with('reference');
L.y.reference = 'preview';

N = 10;
mpc = MPCController(L, N);
Y = mpc.toYALMIP();
% 2 states, 10 preview references
assert(Y.internal.xinitFormat.n_xinit == 2+N*ny);
assert(isequal(Y.internal.xinitFormat.names{1}, 'x.init'));
assert(isequal(Y.internal.xinitFormat.names{2}, 'y.reference'));
assert(isequal(Y.internal.xinitFormat.dims{1}, [2 1]));
assert(isequal(Y.internal.xinitFormat.dims{2}, [N*ny 1]));

x0 = [1; 1];
% reference must be provided
[~, msg] = run_in_caller('[u, f, ol] = mpc.evaluate(x0)');
asserterrmsg(msg, 'Please provide initial value of "y.reference".');

% reference must be of correct size
[~, msg] = run_in_caller('[u, f, ol] = mpc.evaluate(x0, ''y.reference'', 1)');
asserterrmsg(msg, '"y.reference" must be a 10x1 vector.');

ref = [1:5 5:-1:1];
[u, f, ol] = mpc.evaluate(x0, 'y.reference', ref(:));
assert(f);
Jexp = 10.4523024830048;
assert(norm(ol.cost-Jexp)<1e-5);
Yexp = [1 1.97388042422775 2.88309398339912 3.67670650841644 4.21431143073078 4.20533661058294 3.66106902852724 2.90602627391071 2.15425863807015 1.61617835892417];
assert(norm(ol.Y-Yexp, Inf)<1e-5);

end
