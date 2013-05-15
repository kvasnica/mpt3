function test_union_01_fail
%
% no concatenation between convexset
%

x = sdpvar(1);
F = set(x>0);
U = Union([Polyhedron,YSet(x,F)]);

end