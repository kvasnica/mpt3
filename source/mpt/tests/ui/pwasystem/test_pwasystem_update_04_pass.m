function test_pwasystem_update_04_pass
% PWASystem/update() for non-autonomous systems should fail if no input is
% provided

opt_sincos;
L = PWASystem(sysStruct);

% first dynamics
x0 = [2; 2]; u = 1;
xgood = [-0.585640646055102; 3.1856406460551];
L.initialize(x0);
[worked, msg] = run_in_caller('L.update(); ');
assert(~worked);
asserterrmsg(msg,'System is not autonomous, please provide the input.');

end

