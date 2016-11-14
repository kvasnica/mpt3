function test_polyhedron_38_pass
%
% polyhedron constructor test
% 
% 

% call using redundant strings
[worked, msg] = run_in_caller('Polyhedron(''abcDe'',[],''nothing'',1,''h'',[1 1]); ');
assert(~worked);
asserterrmsg(msg,'Input argument must be a "Polyhedron" class.');
