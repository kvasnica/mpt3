function test_polyhedron_chebyCenter_12_pass
%
% redundant polyhedron if facet is required
%

P = Polyhedron(randn(5), rand(5,1));

% facet 1 
[worked, msg] = run_in_caller('xc = P.chebyCenter(1); ');
assert(~worked);
asserterrmsg(msg,'Polyhedron must be in minimal representation when you want compute Chebyshev centre any of its facets. Use "minHRep()" to compute the facets.');

end
