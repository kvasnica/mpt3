function test_mldsystem_plot_01_pass
% tests MLDSystem/plot

model = MLDSystem('pwa_car');
model.x.penalty = OneNormFunction(100*eye(2));
model.u.penalty = OneNormFunction(0.1);
M = MPCController(model, 5);
M.evaluate([-5; -5]);
M.model.plot();

end
