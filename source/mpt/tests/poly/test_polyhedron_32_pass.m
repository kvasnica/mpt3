function test_polyhedron_32_pass
%
% polyhedron constructor test
% 
% 

% dimension mismatch
[worked, msg] = run_in_caller('Polyhedron(''V'',randn(3),''ub'',ones(3,1),''H'',[-1; 2]); ');
assert(~worked);
asserterrmsg(msg,'Input matrices must have the same dimension');

end
