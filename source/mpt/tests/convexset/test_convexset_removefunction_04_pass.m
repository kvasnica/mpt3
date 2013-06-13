function test_convexset_removefunction_04_pass
%
% wrong indexing
%

P = Polyhedron;
P.addFunction(Function(@(x)x),'primal');

[worked, msg] = run_in_caller('P.removeFunction(1)');
assert(~worked);
asserterrmsg(msg,'The argument must be given as string');

end