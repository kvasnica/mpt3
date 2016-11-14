function test_polyunion_minus_07_pass
%
% convex, unbounded, overlapping union - low-dim polyhedron
%

P(1) = Polyhedron('lb',[-1;-1],'ub',[1;1]);
P(2) = Polyhedron('lb',[-1;-1],'ub',[1;1],'Ae',randn(1,2),'be',0);
P(3) = Polyhedron('V',[1 -1;1 1],'R',[1 0]);


U = PolyUnion('Set',P,'Convex',true,'Bounded',false,'FullDim',true,'Overlaps',false);

W = Polyhedron('lb',[0;0],'ub',[0;1]);

Un = U-W;

if Un.Num~=1
    error('Must be one polyhedron only.')
end
if Un.Set(1).isBounded
    error('The minkowski difference must remain unbounded.');
end
end