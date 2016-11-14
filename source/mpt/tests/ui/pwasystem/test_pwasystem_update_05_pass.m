function test_pwasystem_update_05_pass
% PWASystem/update() should fail if input has wrong dimension

opt_sincos;
L = PWASystem(sysStruct);
nu = size(sysStruct.B{1}, 2);

% first dynamics
x0 = [2; 2]; u = 1;
L.initialize(x0);
[worked, msg] = run_in_caller('L.update(zeros(nu+1, 1)); ');
assert(~worked);
asserterrmsg(msg,'The input must be a 1x1 vector.');

end

