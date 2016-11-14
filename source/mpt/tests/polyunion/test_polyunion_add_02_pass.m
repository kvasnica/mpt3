function test_polyunion_add_02_pass
%
% add low-dim polyhedron to convex union that does built convex union
%

P=Polyhedron('lb',[0;0],'ub',[1;1]);

% is convex automatically
PU = PolyUnion('Set',P,'Convex',true);

Q=Polyhedron('V',[1 0;1 1]);

% if Q is added, the convexity remains
PU.add(Q);


end