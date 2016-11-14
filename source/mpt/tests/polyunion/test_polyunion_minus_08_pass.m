function test_polyunion_minus_08_pass
%
% bounded,bounded, unbunded - unbounded
%

P(1) = Polyhedron('lb',-1,'ub',0);
P(2) = Polyhedron('lb',0,'ub',1);
P(3) = Polyhedron('lb',1);
U = PolyUnion(P);

Un=U-Polyhedron('lb',0);

if Un.Num~=1
    error('Must be 1 region.')
end


end