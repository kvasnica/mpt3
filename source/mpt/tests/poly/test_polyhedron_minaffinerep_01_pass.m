function test_polyhedron_minaffinerep_01_pass
% implicit equalities must be converted to explicit ones

A = [eye(2); -eye(2); 1 0; -1 0];
b = [ones(4, 1); 0; 0];
P = Polyhedron(A, b);
assert(size(P.H, 1)==size(A, 1));
P.minAffineRep();
H_exp = [-1 0 1;0 -1 1;0 1 1;1 0 1];
He_exp = [-1 0 0];
assert(norm(sortrows(P.H)-H_exp)<1e-6);
assert(norm(sortrows(P.He)-He_exp)<1e-6);

end
