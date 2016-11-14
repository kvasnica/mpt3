function test_polyhedron_dual_02_pass
% tests Polyhedron/dual for some bounded, full-dimensional stuff

% unit box in H-rep
A = [-1 0; 0 -1; 1 0; 0 1]; b = ones(4, 1);
P = Polyhedron(A, b);
D = P.dual();
assert(D.hasVRep);
assert(isequal(D.V, A));
% for bounded polyhedra we have that the dual of a dual is the original
Dd = D.dual();
assert(Dd==P);

% unit box in V-rep
V = [1 1; 1 -1; -1 1; -1 -1];
P = Polyhedron(V);
D = P.dual();
assert(D.hasHRep);
assert(isequal(D.A, V));
assert(isequal(D.b, ones(4, 1)));
% for bounded polyhedra we have that the dual of a dual is the original
Dd = D.dual();
assert(Dd==P);

% polytope which does not contain the origin
P = Polyhedron('H', [-1 0 -1;0 -1 -1;1 0 2;0 1 2]);
D = P.dual();
Vexp = [-0.5 1.5;1.5 -0.5;3.5 1.5;1.5 3.5];
assert(norm(D.V - Vexp, Inf) < 1e-6);

% the same but the input is in the V-representation
P = Polyhedron([2 1;1 1;1 2;2 2]);
D = P.dual();
Vexp = [-0.5 1.5;1.5 -0.5;3.5 1.5;1.5 3.5];
assert(norm(sortrows(D.V) - sortrows(Vexp), Inf) < 1e-6);

end
