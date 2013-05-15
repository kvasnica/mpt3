function test_pwasystem_invset_02_pass
% PWASystem/invariantSet with non-autonomous system = CinfSet

opt_sincos
sysStruct.xmax = sysStruct.ymax;
sysStruct.xmin = sysStruct.ymin;
model = mpt_import(sysStruct, probStruct);
[C, dyn] = model.invariantSet('X', model.x.boundsToPolyhedron);
H1 = [-1 -1.73205080756888 25;1 -0 4.4563796348914e-16;-1 -0 10;-0 -1 10;0 1 10];
H2 = [-1 -0 0;1 -1.73205080756888 25;-0 -1 10;1 0 10;0 1 10];
assert(isa(C, 'Polyhedron'));
assert(length(C)==2);
assert(C(1)==Polyhedron('H', H1));
assert(C(2)==Polyhedron('H', H2));
assert(isequal(dyn, [1 2]));

end
