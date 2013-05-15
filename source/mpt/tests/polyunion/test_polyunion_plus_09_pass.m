function test_polyunion_plus_09_pass
%
% bounded,bounded + unbounded
%

P(1) = Polyhedron('lb',[-1;-1],'ub',[0;0]);
P(2) = Polyhedron('lb',[-1;0],'ub',[0;1]);

U = PolyUnion(P);

Un=U+Polyhedron('lb',[0;0]);

if Un.isBounded
    error('Must be unbounded.')
end

end