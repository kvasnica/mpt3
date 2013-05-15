function test_pwasystem_01_fail
% import from multiple LTISystems should fail if systems have various
% dimensions

Double_Integrator;
L1 = LTISystem(sysStruct);

clear sysStruct
ThirdOrder;
L2 = LTISystem(sysStruct);

P = PWASystem([L1 L2]);

end
