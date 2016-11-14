function test_polyhedron_chebyCenter_13_pass
%
% wrong facet specification
%

P = Polyhedron(randn(18,3), rand(18,1));

P.minHRep();
% facet 1.2?
[worked, msg] = run_in_caller('xc = P.chebyCenter(1.2); ');
assert(~worked);
asserterrmsg(msg,'Input argument is a not valid index set.');

end
