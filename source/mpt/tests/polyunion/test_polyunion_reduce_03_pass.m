function test_polyunion_reduce_03_pass
%
% full-dim, low-dim polyhedron
%

P(1) = Polyhedron('lb',[-1,0],'ub',[0;1]);
P(2) = Polyhedron('lb',[0,0],'ub',[0;1]);
U = PolyUnion('set',P);
U.reduce;
if U.Num~=1
    error('Must be one element.');
end

end