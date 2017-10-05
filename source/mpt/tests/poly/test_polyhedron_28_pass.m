function test_polyhedron_28_pass
%
% polyhedron constructor test
% 
% 

% do not accept NaN in ub
V = randn(3,1);
V(1) = NaN;
[worked, msg] = run_in_caller('Polyhedron(''ub'',V); ');
assert(~worked);
asserterrmsg(msg,'Input argument must be a real vector.');

end
