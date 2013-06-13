function test_ltisystem_11_pass
% import of PWA from sysStruct should fail

opt_sincos;
[worked, msg] = run_in_caller('L = LTISystem(sysStruct); ');
assert(~worked);
asserterrmsg(msg,'Use PWASystem for PWA systems.');

end

