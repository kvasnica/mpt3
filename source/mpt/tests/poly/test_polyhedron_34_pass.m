function test_polyhedron_34_pass
%
% polyhedron constructor test
% 
% 

% no cells please
[worked, msg] = run_in_caller('Polyhedron(''H'',{[1 2]},''HE'',[1 3]); ');
assert(~worked);
asserterrmsg(msg,'Input argument must be a real matrix.');
