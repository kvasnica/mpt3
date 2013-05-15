function test_pwasystem_update_01_fail
% PWASystem/update() for non-autonomous systems should fail if no input is
% provided

opt_sincos;
L = PWASystem(sysStruct);

% first dynamics
x0 = [2; 2]; u = 1;
xgood = [-0.585640646055102; 3.1856406460551];
L.initialize(x0);
L.update();

end

