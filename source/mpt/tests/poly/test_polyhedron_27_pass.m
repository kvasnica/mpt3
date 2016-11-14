function test_polyhedron_27_pass
%
% polyhedron constructor test
% 
% 

% do not accept NaN in lb
V = randn(3,1);
V(1) = NaN;
[worked, msg] = run_in_caller('Polyhedron(''lb'',V); ');
assert(~worked);
asserterrmsg(msg,'Input argument must be a real vector.');
