function test_polyhedron_37_pass
%
% polyhedron constructor test
% 
% 

% try complex number
[worked, msg] = run_in_caller('Polyhedron(j);');
assert(~worked);
asserterrmsg(msg,'Input argument must be a real matrix.');

end
