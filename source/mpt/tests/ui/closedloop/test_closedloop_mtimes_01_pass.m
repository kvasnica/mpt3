function test_closedloop_mtimes_01_pass
% A*B creates a closed-loop system (here we assume a linear controller)

%% state-feedback controllers (multiplication by a matrix)
sys = LTISystem('A', eye(2), 'B', [1; 0]);

% wrong number of states
K = 1;
[~, msg] = run_in_caller('K*sys');
asserterrmsg(msg, 'The gain must have 2 column(s).');
% wrong number of inputs
K = eye(2);
[~, msg] = run_in_caller('K*sys');
asserterrmsg(msg, 'The gain must have 1 row(s).');
% one of the inputs must be a controller
K = sys;
[~, msg] = run_in_caller('K*sys');
asserterrmsg(msg, 'Unsupported inputs.');
K = 'bogus';
[~, msg] = run_in_caller('K*sys');
asserterrmsg(msg, 'Unsupported inputs.');
[~, msg] = run_in_caller('sys*K');
asserterrmsg(msg, 'Unsupported inputs.');
% % to make these work, we need to specify InferiorTo in AbstractSystem:
% K = Polyhedron;
% [~, msg] = run_in_caller('K*sys');
% asserterrmsg(msg, 'Unsupported inputs.');
% K = Polyhedron;
% [~, msg] = run_in_caller('sys*K');
% asserterrmsg(msg, 'Unsupported inputs.');

% correct behavior
K = [1 1];
loop = K*sys;
assert(isa(loop, 'ClosedLoop'));
assert(loop.controller.evaluate([3; 4])==7);

K = [1 1];
loop = sys*K;
assert(isa(loop, 'ClosedLoop'));
assert(loop.controller.evaluate([3; 4])==7);

K = [1 1];
ctrl = SFController(sys, K);
loop = ctrl*sys;
assert(isa(loop, 'ClosedLoop'));
assert(loop.controller.evaluate([3; 4])==7);

end
