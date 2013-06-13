function test_polyhedron_isFullDim_01_pass
%
% isFullDim test
% 
% 

P = Polyhedron;
Q = P;
[worked, msg] = run_in_caller('isFullDim(P,Q); ');
assert(~worked);
asserterrmsg(msg,'Too many input arguments.');
