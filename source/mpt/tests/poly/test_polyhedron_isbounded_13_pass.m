function test_polyhedron_isbounded_13_pass
%
% isbounded test
% 
% 

P = Polyhedron;
Q = P;
[worked, msg] = run_in_caller('isBounded(P,Q); ');
assert(~worked);
asserterrmsg(msg,'Too many input arguments.');
