function test_polyhedron_affinemap_10_pass
%
% wrong dimension
%

P = Polyhedron('H',randn(5));

[worked, msg] = run_in_caller('Q = P.affineMap(randn(3)); ');
assert(~worked);
asserterrmsg(msg,'The matrix representing the affine map must have 4 number of columns.');

end