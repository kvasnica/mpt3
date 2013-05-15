function test_polyhedron_chebyCenter_03_fail
%
% wrong facet specification
%

P = Polyhedron(randn(18,3), rand(18,1));

P.minHRep();
% facet 1.2?
xc = P.chebyCenter(1.2);

end
