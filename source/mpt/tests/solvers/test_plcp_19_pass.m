function test_plcp_19_pass
% tests that we compute feasible set in mpt_plcp

Double_Integrator; probStruct.Tconstraint = 0; probStruct.P_N = eye(2);
model = mpt_import(sysStruct, probStruct);
E = EMPCController(model, 2);
assert(isa(E.optimizer.Internal.convexHull, 'Polyhedron'));
Hgood = Polyhedron('H', [-0.707106781186547 -0.707106781186547 4.24264068711928;0 -1 5;1 0 5;0.707106781186547 0.707106781186547 4.24264068711928;0 1 5;-1 0 5]);
assert(E.optimizer.Internal.convexHull==Hgood);
