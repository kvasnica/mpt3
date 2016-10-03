function test_polyhedron_affineHull_12_pass
% H must be returned

He = [1 0 0 0];
A = [eye(3); -eye(3); 0 1 0; 0 -1 0];
b = [ones(6, 1); zeros(2, 1)];
H = [A b];
P = Polyhedron('H', H, 'He', He);
[Hea, Ha] = P.affineHull();
Hea_exp = [0 -1 0 0;1 0 0 0];
Ha_exp = [-1 0 0 1;0 -1 0 1;0 0 -1 1;0 0 1 1;0 1 0 1;1 0 0 1];
assert(norm(sortrows(Hea)-Hea_exp)<1e-6);
assert(norm(sortrows(Ha)-Ha_exp)<1e-6);

end
