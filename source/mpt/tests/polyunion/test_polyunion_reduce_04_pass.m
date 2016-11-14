function test_polyunion_reduce_04_pass
%
% full-dim, full-dim polyhedron
%

P(1) = Polyhedron('lb',[-1,0],'ub',[0;1]);
P(2) = Polyhedron('lb',[0,0],'ub',[1;1]);
U = PolyUnion('set',P,'Overlaps',false,'convex',true);
U.reduce;
if U.Num~=2
    error('Must be two elements.');
end

end