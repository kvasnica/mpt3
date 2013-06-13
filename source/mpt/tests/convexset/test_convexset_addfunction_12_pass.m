function test_convexset_addfunction_12_pass
%
% random polytope, same string again
%

P = Polyhedron(randn(5));
[worked, msg] = run_in_caller('P.addFunction([AffFunction(-1,2);AffFunction(1,-2)],{''primal'',''''}); ');
assert(~worked);
asserterrmsg(msg,'Too many input arguments.');
[worked, msg] = run_in_caller('P.addFunction(AffFunction(2),{''primal''}); ');
assert(~worked);
asserterrmsg(msg,'The function must have the same domain as the set.')

end