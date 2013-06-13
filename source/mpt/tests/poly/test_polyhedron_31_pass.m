function test_polyhedron_31_pass
%
% polyhedron constructor test
% 
% 

% dimension mismatch
[worked, msg] = run_in_caller('Polyhedron(''H'',randn(3),''lb'',1); ');
assert(~worked);
asserterrmsg(msg,'Upper lower bounds must be of length 2');
