function test_polytope_uminus_01_pass
% tests polytope/uminus

P = polytope([0 0; 0 1; 1 0; 1 1]);
expected = polytope([0 0; 0 -1; -1 0; -1 -1]);
Q = -P;
assert(Q==expected);

end