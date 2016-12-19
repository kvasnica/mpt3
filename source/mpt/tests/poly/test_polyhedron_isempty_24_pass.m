function test_polyhedron_isempty_24_pass
%
% isempty test
% 
% 

P = Polyhedron;
[worked, msg] = run_in_caller('P.isEmptySet(P); ');
assert(~worked);
asserterrmsg(msg,'Too many input arguments.');

end
