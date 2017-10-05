function test_polyhedron_30_pass
%
% polyhedron constructor test
% 
% 

% P is not a polyhedron
[worked, msg] = run_in_caller('Polyhedron(''P'',randn(3)); ');
assert(~worked);
asserterrmsg(msg,'Input argument must be a "Polyhedron" class.');

end
