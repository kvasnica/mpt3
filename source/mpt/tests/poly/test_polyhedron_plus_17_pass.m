function test_polyhedron_plus_17_pass
% v+P must work (issue #59)

P = Polyhedron(randn(10, 2));
v = randn(2, 1);

Q1 = P+v;
Q2 = v+P;
assert(Q1==Q2);

end
