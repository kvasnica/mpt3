function test_polyhedron_getfacet_04_pass
%
% V-rep
%

P = ExamplePoly.randVrep('d',4);
P.minHRep();

Q=P.getFacet(6);


if ~P.contains(Q)
    error('Q is not the face of P.');
end

if Q.isFullDim
    error('Q must be lower-dimensional.');
end


end
