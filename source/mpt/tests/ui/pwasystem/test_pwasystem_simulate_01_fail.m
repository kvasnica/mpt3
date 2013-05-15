function test_pwasystem_simulate_01_fail
% PWASystem/simulate() should fail when the sequence of inputs is not
% provided for non-autonomous systems

opt_sincos;
P = PWASystem(sysStruct);

x0 = [2;2];
P.initialize(x0);
D = P.simulate();

end

