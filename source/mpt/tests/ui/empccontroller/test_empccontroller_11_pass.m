function test_empccontroller_11_pass
% import from empty PolyUnion should fail

PU = PolyUnion;
[worked, msg] = run_in_caller('E = EMPCController(PU); ');
assert(~worked);
asserterrmsg(msg,'Optimizer 1 must contain at least one region.');

end
