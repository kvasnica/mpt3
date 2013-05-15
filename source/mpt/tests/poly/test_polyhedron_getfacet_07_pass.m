function test_polyhedron_getfacet_07_pass
%
% empty polyhedron
%

P = Polyhedron(randn(34,3),randn(34,1));
P.minHRep();

Q = P.getFacet(5);

if ~Q.isEmptySet
    error('Q must be empty.');
end


end
