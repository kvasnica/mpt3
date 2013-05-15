function test_polyunion_add_01_fail
%
% add low-dim polyhedron to convex union that does not built convex union
%

P=Polyhedron('lb',[0;0],'ub',[1;1]);

PU = PolyUnion('Set',P,'Convex',true);

Q=Polyhedron('V',[1 0],'R',[0 1]);

% if Q is added, the convexity remains
PU.add(Q);


end