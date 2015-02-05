function test_closedloop_mtimes_02_pass
% A*B creates a closed-loop system (here we assume an MPC controller)

%% state-feedback controllers (multiplication by a matrix)
sys = LTISystem('A', 1, 'B', 1);
sys.x.min = -10;
sys.x.max = 10;
sys.u.min = -1;
sys.u.max = 1;
sys.x.penalty = QuadFunction(1);
sys.u.penalty = QuadFunction(1);
ctrl = MPCController(sys, 3);

% wrong number of states
sys2 = LTISystem('A', [1 0; 0 1], 'B', [1; 0]);
[~, msg] = run_in_caller('ctrl*sys2');
asserterrmsg(msg, 'Incompatible number of states.');
% wrong number of inputs
sys2 = LTISystem('A', 1, 'B', [1 1]);
[~, msg] = run_in_caller('ctrl*sys2');
asserterrmsg(msg, 'Incompatible number of inputs.');

% correct behavior
loop = ctrl*sys;
assert(isa(loop, 'ClosedLoop'));
loop = sys*ctrl;
assert(isa(loop, 'ClosedLoop'));

% correct behavior with tracking (extended state vector)
sys = LTISystem('A', 1, 'B', 1);
sys.x.min = -10;
sys.x.max = 10;
sys.u.min = -1;
sys.u.max = 1;
sys.x.penalty = QuadFunction(1);
sys.u.penalty = QuadFunction(1);
sys.x.with('reference');
sys.x.reference = 'free';
ctrl = MPCController(sys, 3);
ctrl.construct();
assert(ctrl.xinitFormat.n_xinit==2);
assert(ctrl.nx==1);
loop = ctrl*sys;
assert(isa(loop, 'ClosedLoop'));
[~, msg] = run_in_caller('d = loop.simulate(3, 10)');
asserterrmsg(msg, 'Please provide initial value of "x.reference".');
ref = 1.1;
d = loop.simulate(3, 20, 'x.reference', ref);
assert(size(d.X, 2)==21);
assert(norm(d.X(:, end)-ref)<1e-4);

end
