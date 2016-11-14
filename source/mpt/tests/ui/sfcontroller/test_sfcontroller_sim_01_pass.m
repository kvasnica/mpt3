function test_sfcontroller_sim_01_pass
% tests SFController/evaluate

% 1 state, 1 input
A = [1 1; 0 1]; B = [1; 0.5];
sys = LTISystem('A', A, 'B', B);
K = dlqr(A, B, eye(2), 1);
ctrl = SFController(sys, -K);
x0 = [4; 0];
d = ctrl.simulate(x0, 10);
Uexp = [-2.07901602980944 -0.0213457243932591 0.540069295180331 0.551380732142202 0.411145278969347 0.266414277502166 0.158081088617976 0.0877338632557979 0.0459299528416648 0.0227007291986956];
assert(norm(d.U-Uexp)<1e-6);

end
