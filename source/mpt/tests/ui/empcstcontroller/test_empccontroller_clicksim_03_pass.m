function test_empccontroller_clicksim_03_pass
% simulation with a custom model

N = 1;
L = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
L.x.penalty = QuadFunction(eye(2));
L.u.penalty = QuadFunction(1);
L.u.min = -1;
L.u.max = 1;
L.x.min = [-5; -5];
L.x.max = [5; 5];
ctrl = EMPCController(L, N);
assert(ctrl.nr==3);

simmodel = LTISystem('A', eye(2), 'B', [1; 0.5]);
x0 = [2; 0];
d = ctrl.clicksim('model', simmodel, 'x0', x0);
assert(sum(d.cost)==200);

close

end
