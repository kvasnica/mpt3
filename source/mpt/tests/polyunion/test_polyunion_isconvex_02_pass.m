function test_polyunion_isconvex_02_pass
%
% not convex
%

P(1)=Polyhedron('lb',[0;0],'ub',[1;1]);
P(2)=Polyhedron('lb',[-1;0],'ub',[2;1]);


PU = PolyUnion(P);


if ~PU.isConvex
    error('Is not convex union.');
end

end