function test_polyhedron_39_pass
%
% polyhedron constructor test
% 
% 

% too many polytopes
[worked, msg] = run_in_caller('P = Polyhedron(randn(2,3),randn(3,1)); ');
assert(~worked);
asserterrmsg(msg,'Number of rows does not hold between arguments "A", "b".');

end
