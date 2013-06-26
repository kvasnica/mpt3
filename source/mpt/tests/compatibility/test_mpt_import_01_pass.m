function test_mpt_import_01_pass
% move blocking

Double_Integrator
probStruct.Tconstraint = 0;
probStruct.Nc = 2;

sys = mpt_import(sysStruct, probStruct);
ctrl = MPCController(sys, probStruct.N);
x0 = [1; 1];
[~, ~, ol] = ctrl.evaluate(x0);
Ugood = [-0.999999999978609 -0.549999999950715 -0.549999999950715 -0.549999999950715 -0.549999999950715];
Jgood = 6.9125000001246;
assert(abs(ol.cost - Jgood) <= 1e-6);
assert(norm(ol.U - Ugood, Inf) <= 1e-6);

end
