function test_mpccontroller_tracking_07_pass
% same as test_mpccontroller_tracking_06_pass but with ny=2

ny = 2;
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
asserterrmsg(msg, '"y.reference" must be a 20x1 vector.');

ref = [[1:5 5:-1:1]; [zeros(1, 5), ones(1, 5)]];
[u, f, ol] = mpc.evaluate(x0, 'y.reference', ref(:));
assert(f);
Jexp = 18.8950570408202;
assert(norm(ol.cost-Jexp)<1e-5);
Yexp = [1 1.82202920858176 2.6163711474603 3.32261567405673 3.84067722208755 3.99661365602795 3.60215455953644 2.99742766677281 2.39831321444418 2.01596446856019;1 1.01101460429088 1.08488119244289 1.15719997426569 1.16989232855393 1.04698210345592 0.725922869084997 0.420813444114332 0.210592262570128 0.153953079787489];
assert(norm(ol.Y-Yexp, Inf)<1e-5);

end
