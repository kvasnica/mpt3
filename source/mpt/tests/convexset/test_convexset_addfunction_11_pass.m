function test_convexset_addfunction_11_pass
%
% random polytope, 2 same names of linear functions
%

P = Polyhedron(randn(5));
[worked, msg] = run_in_caller('P.addFunction([AffFunction(-1,2);AffFunction(1,2)],{''primal'',''primal''}); ');
assert(~worked);
asserterrmsg(msg,'Too many input arguments.');

end