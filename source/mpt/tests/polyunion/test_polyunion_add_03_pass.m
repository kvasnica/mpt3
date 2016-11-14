function test_polyunion_add_03_pass
%
% add unbounded polyhedron to convex union that does built convex union
%

P(1)=Polyhedron('lb',[0;0],'ub',[1;1]);
P(2)=Polyhedron('lb',[1;0],'ub',[2;1]);

PU = PolyUnion('set',P,'convex',true,'overlaps',false);

Q=Polyhedron('V',[2 0;2 1],'R',[1,0]);

% if Q is added, the convexity remains
PU.add(Q);


end