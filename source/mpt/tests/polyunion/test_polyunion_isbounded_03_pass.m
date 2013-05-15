function test_polyunion_isbounded_03_pass
%
% not-bounded set
%

P(1) = Polyhedron('lb',[0;0;0]);
P(2) = Polyhedron('R',[1, 0, 0; 0 0.4 -1]);


PU = PolyUnion(P);

if PU.isBounded
    error('This union is not bounded.');
end


end