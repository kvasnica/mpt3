function test_polyhedron_getfacet_01_pass
%
% H-rep
%

P = ExamplePoly.randHrep;
P.minHRep();

Q=P.getFacet(1);


if ~P.contains(Q)
    error('Q is not the face of P.');
end

if Q.isFullDim
    error('Q must be lower-dimensional.');
end

end
