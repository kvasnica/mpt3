function test_pwasystem_04_pass
% import from multiple LTISystems should fail if systems have various
% dimensions

Double_Integrator;
L1 = LTISystem(sysStruct);

clear sysStruct
ThirdOrder;
L2 = LTISystem(sysStruct);

[worked, msg] = run_in_caller('P = PWASystem([L1 L2]); ');
assert(~worked);
asserterrmsg(msg,'All systems must have identical state dimensions.');

end
