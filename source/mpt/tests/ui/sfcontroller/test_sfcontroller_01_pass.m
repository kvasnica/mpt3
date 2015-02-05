function test_sfcontroller_01_pass
% tests the SFController constructor with wrong inputs

% model must be provided
K = 1;
[~, msg] = run_in_caller('ctrl = SFController(K)');
asserterrmsg(msg, 'Not enough input arguments.');

% controller must be provided
sys = LTISystem('A', 1, 'B', 1);
[~, msg] = run_in_caller('ctrl = SFController(sys)');
asserterrmsg(msg, 'Not enough input arguments.');

% system, controller in this order
K = 1;
sys = LTISystem('A', 1, 'B', 1);
[~, msg] = run_in_caller('ctrl = SFController(K, sys)');
asserterrmsg(msg, 'The first input must be a system model.');

% wrong number of states
K = [1 2];
sys = LTISystem('A', 1, 'B', 1);
[~, msg] = run_in_caller('ctrl = SFController(sys, K)');
asserterrmsg(msg, 'The gain must have 1 column(s).');

end
