function test_pwasystem_update_02_fail
% PWASystem/update() should fail if input has wrong dimension

opt_sincos;
L = PWASystem(sysStruct);
nu = size(sysStruct.B{1}, 2);

% first dynamics
x0 = [2; 2]; u = 1;
L.initialize(x0);
L.update(zeros(nu+1, 1));

end

