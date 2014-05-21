function test_convexset_02_pass
%
% constructing convex set directly is not possible
%

[worked, msg] = run_in_caller('a=ConvexSet(1);');
assert(~worked);
asserterrmsg(msg,'Abstract classes cannot be instantiated.');
