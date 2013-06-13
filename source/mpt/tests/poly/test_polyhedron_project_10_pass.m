function test_polyhedron_project_10_pass
%
% wrong value in x
%

P(1) = ExamplePoly.randHrep('d',4);
P(2) = ExamplePoly.randHrep('d',4,'ne',1);
[worked, msg] = run_in_caller('d = P.project([1,2,Inf,Inf]); ');
assert(~worked);
asserterrmsg(msg,'This method does not support arrays. Use the forEach() method.');


end