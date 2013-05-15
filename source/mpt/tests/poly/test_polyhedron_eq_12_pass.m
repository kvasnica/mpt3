function test_polyhedron_eq_12_pass
% tests lowdim==fulldim

% these two are for sure not equal
P=Polyhedron('lb',[0;0],'ub',[1;1]);
Q=Polyhedron('V',[1 0;0 1]);
assert(~(P==Q));
assert(P~=Q);

% now with P in Vrep
P=Polyhedron('lb',[0;0],'ub',[1;1]); P.computeVRep(); % compute Vrep
Q=Polyhedron('V',[1 0;0 1]);
assert(~(P==Q));
assert(P~=Q);

% now with Q in Hrep
P=Polyhedron('lb',[0;0],'ub',[1;1]);
Q=Polyhedron('V',[1 0;0 1]); Q.computeHRep(); % compute Hrep
assert(~(P==Q));
assert(P~=Q);

% and now both in Vrep/Hrep (used to be a problem in Polyhedron/contains)
P=Polyhedron('lb',[0;0],'ub',[1;1]); P.computeVRep(); % compute Vrep
Q=Polyhedron('V',[1 0;0 1]); Q.computeHRep(); % compute Hrep
assert(~(P==Q));
assert(P~=Q);

end
