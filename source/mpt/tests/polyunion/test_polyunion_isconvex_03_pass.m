function test_polyunion_isconvex_03_pass
%
% random polyhedra, definitely not convex
%

P(1) = ExamplePoly.randVrep('d',3);
P(2) = ExamplePoly.randVrep('d',3);
P(3) = ExamplePoly.randVrep('d',3,'nr',1);
P(4) = ExamplePoly.randHrep('d',3,'ne',1);


PU = PolyUnion(P);


if PU.isConvex
    error('Is not convex union.');
end

end