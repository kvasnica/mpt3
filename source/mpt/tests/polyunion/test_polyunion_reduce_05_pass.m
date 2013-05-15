function test_polyunion_reduce_05_pass
%
% full-dim, full-dim polyhedron
%

P(1) = Polyhedron('lb',[-1,0],'ub',[0;1]);
P(2) = 0.8*P(1);
U = PolyUnion('set',P);
U.reduce;
if U.Num~=1
    error('Must be one element.');
end

end