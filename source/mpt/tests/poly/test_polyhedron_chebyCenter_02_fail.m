function test_polyhedron_chebyCenter_02_fail
%
% redundant polyhedron if facet is required
%

P = Polyhedron(randn(5), rand(5,1));

% facet 1 
xc = P.chebyCenter(1);

end
