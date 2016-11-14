function test_polyunion_isconnected_03_pass
%
% 3D random polyhedra
%

P(1)=ExamplePoly.randHrep('d',3);
P(2)=ExamplePoly.randHrep('d',3);
P(3)=ExamplePoly.randHrep('d',3);
P(4)=ExamplePoly.randHrep('d',3);

PU = PolyUnion(P);

if ~PU.isConnected
    error('Connectivity expected here.');
end


end
