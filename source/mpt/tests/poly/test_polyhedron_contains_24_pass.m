function test_polyhedron_contains_24_pass
% tests combination lowdim and fulldim in both Vrep and Hrep

% this problem used to occur only when both polyhedra are in both
% representations

% both reps for P and Q
P=Polyhedron('lb',[0;0],'ub',[1;1]); P.computeVRep(); % compute Vrep
Q=Polyhedron('V',[1 0;0 1]); Q.computeHRep(); % compute Hrep
assert(P.contains(Q));
assert(~Q.contains(P));

% P in Hrep, Q in both
P=Polyhedron('lb',[0;0],'ub',[1;1]);
Q=Polyhedron('V',[1 0;0 1]); Q.computeHRep(); % compute Hrep
assert(P.contains(Q));
assert(~Q.contains(P));

% Q in Vrep, P in both
P=Polyhedron('lb',[0;0],'ub',[1;1]); P.computeVRep(); % compute Vrep
Q=Polyhedron('V',[1 0;0 1]);
assert(P.contains(Q));
assert(~Q.contains(P));

% Q in Vrep, P in Hrep
P=Polyhedron('lb',[0;0],'ub',[1;1]);
Q=Polyhedron('V',[1 0;0 1]);
assert(P.contains(Q));
assert(~Q.contains(P));

end
