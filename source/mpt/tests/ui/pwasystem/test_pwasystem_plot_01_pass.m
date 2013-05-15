function test_pwasystem_plot_01_pass
% tests PWASystem/plot

opt_sincos
model = mpt_import(sysStruct, probStruct);
M = MPCController(model, 5);
M.evaluate([-5; -5]);
M.model.plot();

end
