function test_union_08_pass
%
% no concatenation between convexset
%

x = sdpvar(1);
F = [x>=0];
[worked, msg] = run_in_caller('U = Union([Polyhedron,YSet(x,F)]); ');
assert(~worked);
asserterrmsg(msg,'Only the same sets can be concatenated.');

end