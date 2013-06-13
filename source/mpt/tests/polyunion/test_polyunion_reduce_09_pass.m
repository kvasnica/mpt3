function test_polyunion_reduce_09
% tests lower-dimensional sets

% there used to be a problem in Polyhedron/contains which affected reduce

% here, Q <= P and should be removed
P=Polyhedron('lb',[0;0],'ub',[1;1]); P.computeVRep(); % compute Vrep
Q=Polyhedron('V',[1 0;0 1]);
U = PolyUnion([P Q]);
U.reduce;
assert(U.Num==1);
assert(isFullDim(U.Set(1))); % must be fulldim
assert(U.Set(1)==P);

% different ordering
P=Polyhedron('lb',[0;0],'ub',[1;1]); P.computeVRep(); % compute Vrep
Q=Polyhedron('V',[1 0;0 1]);
U = PolyUnion([Q P]);
U.reduce;
assert(U.Num==1);
assert(isFullDim(U.Set(1))); % must be fulldim
assert(U.Set(1)==P);

end
