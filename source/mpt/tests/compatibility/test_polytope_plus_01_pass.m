function test_polytope_plus_01_pass
% v+P must work (issue #60)

P = polytope(randn(10, 2));
v = randn(2, 1);

Q1 = P+v;
Q2 = v+P;
assert(Q1==Q2);

end
