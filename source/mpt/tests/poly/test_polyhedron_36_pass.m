function test_polyhedron_36_pass
%
% polyhedron constructor test
% 
% 

% too many args
[worked, msg] = run_in_caller('Polyhedron(randn(2,3),randn(3,1),1); ');
assert(~worked);
asserterrmsg(msg,'Input argument must be a "Polyhedron" class.');

end
