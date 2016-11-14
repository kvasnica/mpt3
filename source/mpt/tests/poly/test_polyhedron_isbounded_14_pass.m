function test_polyhedron_isbounded_14_pass
%
% isbounded test
% 
% 

P = Polyhedron;
[worked, msg] = run_in_caller('P.isBounded(P); ');
assert(~worked);
asserterrmsg(msg,'Too many input arguments.');
