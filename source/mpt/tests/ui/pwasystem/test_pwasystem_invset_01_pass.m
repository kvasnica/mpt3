function test_pwasystem_invset_01_pass
% PWASystem/invariantSet with autonomous system

Double_Integrator
probStruct.norm = 1;
probStruct.N = 1;
model = mpt_import(sysStruct, probStruct);
ctrl = MPCController(model, probStruct.N).toExplicit();
loop = ClosedLoop(ctrl, model).toSystem();

[S, dyn] = loop.invariantSet();
assert(length(S)==12);
assert(isa(S, 'Polyhedron'));
assert(any(contains(S, [4; -3.1])));
assert(~any(contains(S, [4; -3.2])));
%assert(isequal(dyn, [1 1 1 2 3 4 4 5 6 7 8 9 9 10 11 12 12 12]));

end
