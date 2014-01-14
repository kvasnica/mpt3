function test_polytope_merge_01_pass

H = polytope([-10 -10; -10 10; 10 -10; 10 10]);
P1 = polytope([-1 -1; 0 -1; -1 1; 0 1]);
P2 = polytope([0 -1; 0 1; 2 -1; 2 1]);
Q = H\[P1 P2];
assert(isa(Q, 'polytope'));
assert(length(Q)==5);

M = merge(Q);
assert(isa(M, 'polytope'));
assert(length(M)==4);

end