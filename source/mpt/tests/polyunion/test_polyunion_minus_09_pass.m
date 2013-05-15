function test_polyunion_minus_09_pass
%
% bounded,bounded - unbounded
%

P(1) = Polyhedron('lb',[-1;-1],'ub',[0;0]);
P(2) = Polyhedron('lb',[-1;0],'ub',[0;1]);

U = PolyUnion(P);

Un=U-Polyhedron('lb',[0;0]);

if Un.Num~=0
    error('Must be empty union here.');
end

end