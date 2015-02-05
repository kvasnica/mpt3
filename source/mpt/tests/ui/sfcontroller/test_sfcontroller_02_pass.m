function test_sfcontroller_02_pass
% tests the SFController constructor with correct inputs

% 1 state, 1 input
sys = LTISystem('A', 1, 'B', 1);
K = 1;
ctrl = SFController(sys, K);
assert(isa(ctrl, 'SFController'));
assert(ctrl.nx==1);
assert(ctrl.nu==1);

% 2 states, 3 inputs
sys = LTISystem('A', eye(2), 'B', randn(2, 3));
K = randn(3, 2);
ctrl = SFController(sys, K);
assert(isa(ctrl, 'SFController'));
assert(ctrl.nx==2);
assert(ctrl.nu==3);

end
