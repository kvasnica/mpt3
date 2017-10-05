function test_polyhedron_isfulldim_11_pass
%
% isFullDim test
% 
% 

P = Polyhedron;
Q = P;
[worked, msg] = run_in_caller('isFullDim(P,Q); ');
assert(~worked);
asserterrmsg(msg,'Too many input arguments.');

end
