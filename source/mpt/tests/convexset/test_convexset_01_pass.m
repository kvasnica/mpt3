function test_convexset_01_pass
%
% constructing convex set directly is not possible
%

[worked, msg] = run_in_caller('ConvexSet;');
assert(~worked);
asserterrmsg(msg,'Creating an instance of the Abstract class ''ConvexSet'' is not allowed.');
