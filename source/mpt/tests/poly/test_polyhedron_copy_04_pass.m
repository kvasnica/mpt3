function test_polyhedron_copy_04_pass
% tests copying of P.Data

P = Polyhedron('lb', -1, 'ub', 1);
Q = Polyhedron('lb', -1, 'ub', 1);
Q.addFunction(@(x) x, 'f');
P.Data = Q;
C = P.copy();
assert(C.Data.hasFunction('f'));
P.Data.removeFunction('f');
assert(~C.Data.hasFunction('f'));

end
