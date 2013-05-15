function test_polyhedron_chebyCenter_01_fail
%
% the index of the hyperplane is too large
%

P = Polyhedron(randn(3,4));

% whole polyhedron
xc = P.chebyCenter(4);

end
