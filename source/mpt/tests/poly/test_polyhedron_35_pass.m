function test_polyhedron_35_pass
%
% polyhedron constructor test
% 
% 

% dimension mismatch
[worked, msg] = run_in_caller('Polyhedron(randn(4,5),randn(6,1)); ');
assert(~worked);
asserterrmsg(msg,'CAT arguments dimensions are not consistent.');