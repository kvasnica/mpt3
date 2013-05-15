function test_closedloop_01_pass

CL = ClosedLoop;
assert(isempty(CL.system));
assert(isempty(CL.controller));

end
