function test_polyhedron_minaffinerep_03_pass
% implicit inequalities must be moved to He

He = [1 0 0 0];
A = [eye(3); -eye(3); 0 1 0; 0 -1 0];
b = [ones(6, 1); zeros(2, 1)];
H = [A b];
P = Polyhedron('H', H, 'He', He);
P.minAffineRep();
He_exp = [0 -1 0 0;1 0 0 0];
assert(size(P.He, 1)==2);
assert(norm(sortrows(P.He)-He_exp)<1e-6);

end
