function test_polyhedron_isfulldim_02_pass
%
% isFullDim test
% 
% 

[worked, msg] = run_in_caller('P.isFullDim(Polyhedron); ');
assert(~worked);
asserterrmsg(msg,'Undefined variable "P" or class "P.isFullDim".');
