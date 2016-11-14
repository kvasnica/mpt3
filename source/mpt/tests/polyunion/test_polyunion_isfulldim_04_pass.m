function test_polyunion_isfulldim_04_pass
%
% low-dim polyhedra
%

P(1) = ExamplePoly.randHrep('d',5','ne',2);
P(2) = ExamplePoly.randHrep('d',5','ne',1);
P(3) = Polyhedron;

PU = PolyUnion(P);

if PU.isFullDim
    error('The union is not full-dimensional.');
end

if isempty(PU.Internal.FullDim)
    error('The Internal field should be updated.');
end

end