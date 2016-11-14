function test_polyunion_isfulldim_01_pass
%
% union of full-dim polyhedra
%

P(1) = ExamplePoly.randHrep;
P(2) = ExamplePoly.randHrep;
P(3) = ExamplePoly.randVrep;

PU = PolyUnion(P);

if ~PU.isFullDim
    error('The union is full-dimensional.');
end

end