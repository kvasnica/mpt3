function test_pwasystem_initialize_01_fail
% tests PWASystem/initialize() with wrong dimension of the state

opt_sincos;
L = PWASystem(sysStruct);

L.initialize(zeros(L.nx+1));

end

