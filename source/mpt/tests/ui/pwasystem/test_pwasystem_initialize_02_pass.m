function test_pwasystem_initialize_02_pass
% tests PWASystem/initialize() with wrong dimension of the state

opt_sincos;
L = PWASystem(sysStruct);

[worked, msg] = run_in_caller('L.initialize(zeros(L.nx+1)); ');
assert(~worked);
asserterrmsg(msg,'The initial state must be a 2x1 vector.');

end

