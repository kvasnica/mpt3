function test_polyhedron_33_pass
%
% polyhedron constructor test
% 
% 

% lb/ub mismatch
[worked, msg] = run_in_caller('Polyhedron(''ub'',1:3,''lb'',[1 1 4]); ');
assert(~worked);
asserterrmsg(msg,'Polyhedron: Lower bound at element 3 must not be greater than its upper bound.');
