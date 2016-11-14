function test_pwasystem_simulate_03_pass
% PWASystem/simulate() should fail when the sequence of inputs is not
% provided for non-autonomous systems

opt_sincos;
P = PWASystem(sysStruct);

x0 = [2;2];
P.initialize(x0);
[worked, msg] = run_in_caller('D = P.simulate(); ');
assert(~worked);
asserterrmsg(msg,'System is not autonomous, you must provide sequence of inputs as well.');

end

