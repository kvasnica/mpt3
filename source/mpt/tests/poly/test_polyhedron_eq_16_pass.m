function test_polyhedron_eq_16_pass
% comparison with multiple empty sets fails (issue #110)

P = Polyhedron.unitBox(2);
Q = Polyhedron.emptySet(2);

assert(~([P P]==[Q Q]));
assert(~(P==[Q Q]));
assert(~([P P]==Q));
assert(~(P==Q));

end
