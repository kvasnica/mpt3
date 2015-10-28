function test_mpccontroller_construct_02_pass
% tests MPCController/construct(sdpopt)

model = LTISystem('A', 1, 'B', 1);
model.x.penalty = QuadFunction(1);
model.u.penalty = QuadFunction(1);
ctrl = MPCController(model, 2);
opt = sdpsettings('solver', 'fmincon', 'verbose', 2);
ctrl.construct(opt);
t = evalc('ctrl.evaluate(2);');
assert(~isempty(strfind(t, 'Feasibility'))); % was fmincon really used?
ctrl.construct();
t = evalc('ctrl.evaluate(2);')
assert(isempty(t)); % default options should have been used

end