function test_polyhedron_39_pass
%
% polyhedron constructor test
% 
% 

% too many polytopes
[worked, msg] = run_in_caller('P = Polyhedron(randn(2,3),randn(3,1)); ');
assert(~worked);
asserterrmsg(msg,'Dimensions of matrices being concatenated are not consistent.');
