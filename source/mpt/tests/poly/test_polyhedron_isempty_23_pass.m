function test_polyhedron_isempty_23_pass
%
% isempty test
% 
% 

P = Polyhedron;
Q = P;
[worked, msg] = run_in_caller('isEmptySet(P,Q); ');
assert(~worked);
asserterrmsg(msg,'Too many input arguments.');
