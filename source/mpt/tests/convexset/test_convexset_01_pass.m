function test_convexset_01_pass
%
% constructing convex set directly is not possible
%

[worked, msg] = run_in_caller('ConvexSet;');
assert(~worked);
asserterrmsg(msg,'Abstract classes cannot be instantiated.');
