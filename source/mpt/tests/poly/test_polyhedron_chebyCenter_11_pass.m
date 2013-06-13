function test_polyhedron_chebyCenter_11_pass
%
% the index of the hyperplane is too large
%

P = Polyhedron(randn(3,4));

% whole polyhedron
[worked, msg] = run_in_caller('xc = P.chebyCenter(4); ');
assert(~worked);
asserterrmsg(msg,'Facet index must be less than number of inequalities (3).');

end
