function test_convexset_addfunction_10_pass
%
% empty polyhedron, 2 simple functions concatenated in a cell 
%

P = Polyhedron;
[worked, msg] = run_in_caller('P.addFunction({Function(@(x)x);Function(@(x)x.^2)},{''primal'',''objective''}); ');
assert(~worked);
asserterrmsg(msg,'Specified key type does not match the type expected for this container.');

end