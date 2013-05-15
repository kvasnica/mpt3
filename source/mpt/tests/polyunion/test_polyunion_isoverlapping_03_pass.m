function test_polyunion_isoverlapping_03_pass
%
% 3D random polyhedra
%

P(1)=ExamplePoly.randHrep('d',3);
P(2)=ExamplePoly.randHrep('d',3);
P(3)=ExamplePoly.randHrep('d',3);
P(4)=ExamplePoly.randHrep('d',3);

PU = PolyUnion(P);

if ~PU.isOverlapping
    error('Overlaps expected here.');
end


end
