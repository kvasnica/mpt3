function test_sfcontroller_evaluate_01_pass
% tests SFController/evaluate

% 1 state, 1 input
sys = LTISystem('A', eye(2), 'B', [1; 0]);
K = [1 1];
ctrl = SFController(sys, K);
x0 = [4; 5];
uexp = K*x0;
u = ctrl.evaluate(x0);
assert(norm(u-uexp)<1e-8);

end
