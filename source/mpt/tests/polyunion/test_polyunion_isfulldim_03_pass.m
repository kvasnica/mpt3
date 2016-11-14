function test_polyunion_isfulldim_03_pass
%
% union array,  of full-dim polyhedra
%

P(1) = ExamplePoly.randHrep;
P(2) = ExamplePoly.randVrep;
P(3) = Polyhedron;

PU(1) = PolyUnion(P);
PU(2) = PolyUnion([ExamplePoly.randHrep; ExamplePoly.randVrep]);

if any(~PU.isFullDim)
    error('The union is full-dimensional.');
end

end