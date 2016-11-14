function test_polyhedron_mtimes_12_pass
% tests P*M

P = Polyhedron.unitBox(2);
M = [1 1; 0 1];
Q = P*M;
Aexp = P.A*M;
bexp = P.b;
assert(norm(Q.A - Aexp, Inf) < 1e-8);
assert(norm(Q.b - bexp, Inf) < 1e-8);

end
