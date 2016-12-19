function test_polyhedron_20_pass
%
% polyhedron constructor test
% 
% 

% first argument only polyhedron object
[worked, msg] = run_in_caller('Polyhedron({}); ');
assert(~worked);
asserterrmsg(msg,'Input argument must be a "Polyhedron" class.');

end
