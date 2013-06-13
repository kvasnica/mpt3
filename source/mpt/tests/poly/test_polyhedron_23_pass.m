function test_polyhedron_23_pass
%
% polyhedron constructor test
% 
% 

% do not accept NaN in V-representation
V = randn(3,5);
V(1,1) = NaN;
[worked, msg] = run_in_caller('Polyhedron(V); ');
assert(~worked);
asserterrmsg(msg,'Input argument must be a real matrix.');
