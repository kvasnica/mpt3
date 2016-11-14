function test_polyhedron_minaffinerep_04_pass
% implicit equalities must be converted to explicit ones

% automatic conversion on Polyhedron('H', H)
A = [eye(2); -eye(2); 1 0; -1 0];
b = [ones(4, 1); 0; 0];
H = [A, b];
P = Polyhedron('H', H);
P.minAffineRep();
H_exp = [-1 0 1;0 -1 1;0 1 1;1 0 1];
He_exp = [-1 0 0];
assert(norm(sortrows(P.H)-H_exp)<1e-6);
assert(norm(sortrows(P.He)-He_exp)<1e-6);
P.minHRep();
H_exp = [0 -1 1;0 1 1];
He_exp = [-1 0 0];
assert(norm(sortrows(P.H)-H_exp)<1e-6);
assert(norm(sortrows(P.He)-He_exp)<1e-6);

% automatic conversion on Polyhedron('H', H, 'He', He) - equalities must be
% extracted from H and added to He
A = [eye(3); -eye(3); 1 0 0; -1 0 0];
b = [ones(6, 1); 0; 0];
H = [A, b];
He = [0 1 0 1];
P = Polyhedron('H', H, 'He', He);
P.minAffineRep();
H_exp = [-1 0 0 1;0 -1 0 1;0 0 -1 1;0 0 1 1;1 0 0 1];
He_exp = [-1 0 0 0;0 1 0 1];
assert(norm(sortrows(P.H)-H_exp)<1e-6);
assert(norm(sortrows(P.He)-He_exp)<1e-6);

% no automatic conversion on Polyhedron(A, b)
A = [eye(2); -eye(2); 1 0; -1 0];
b = [ones(4, 1); 0; 0];
P = Polyhedron(A, b);
P.minAffineRep();
A_exp = [eye(2); -eye(2)];
b_exp = ones(4, 1);
He_exp = [-1 0 0];
assert(norm(sortrows(P.A)-sortrows(A_exp))<1e-6);
assert(norm(sortrows(P.b)-sortrows(b_exp))<1e-6);
assert(norm(P.He-He_exp)<1e-6);

end
