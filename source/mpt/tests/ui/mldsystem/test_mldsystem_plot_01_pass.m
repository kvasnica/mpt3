function test_mldsystem_plot_01_pass
% tests MLDSystem/plot

model = MLDSystem('pwa_car');
model.x.penalty = Penalty(100*eye(2), 1);
model.u.penalty = Penalty(0.1, 1);
M = MPCController(model, 5);
M.evaluate([-5; -5]);
M.model.plot();

end
