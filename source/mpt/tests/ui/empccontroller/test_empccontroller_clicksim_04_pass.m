function test_empccontroller_clicksim_04_pass
% tests EMPCController/clicksim() with the 'openloop' option

N = 2;
L = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
L.x.penalty = QuadFunction(eye(2));
L.u.penalty = QuadFunction(1);
L.u.min = -1;
L.u.max = 1;
L.x.min = [-5; -5];
L.x.max = [5; 5];
ctrl = EMPCController(L, N);
d = ctrl.clicksim('openloop', true, 'x0', [1; 1]);
assert(size(d.X, 2)==N+1);

end
