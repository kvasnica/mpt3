function test_polyunion_isbounded_04_pass
%
% bounded, low-dim, unbounded set
%

P(1) = Polyhedron('lb',[0;0;0],'ub',[1;1;1]);
P(2) = ExamplePoly.randHrep('d',3,'ne',1);
P(3) = Polyhedron('R',[0,0,1]);


PU = PolyUnion(P);

if PU.isBounded
    error('This union is not bounded.');
end


end