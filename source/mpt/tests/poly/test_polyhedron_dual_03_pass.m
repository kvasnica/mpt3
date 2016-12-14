function test_polyhedron_dual_03_pass
% dual of an unbounded polyhedra

% origin at the boundary
P = Polyhedron([1 0; 0 1], [0; 0]);
D = P.dual();
Q = D.dual();
assert(P==Q);

% origin at the boundary
% http://www-bcf.usc.edu/~shaddin/cs599fa13/slides/lec7.pdf
P = Polyhedron([1 -1; 1 -2], [0; 0]);
D = P.dual();
Vexp = [0 0];
Rexp = [1 -2; 1 -1];
assert(norm(D.V-Vexp)<1e-6);
assert(norm(sortrows(D.R)-Rexp)<1e-6);
Q = D.dual();
assert(P==Q);

% origin in the interior
P = Polyhedron([1 0; 0 1], [1; 1]);
D = P.dual();
Q = D.dual();
assert(P==Q);

% % origin not in the interior
% P = Polyhedron([1 0; 0 1], [-1; -1]);
% D = P.dual();
% Q = D.dual();
% assert(Q<=P);

% origin at the boundary
V = [0 0; 0 1; 1 0];
R = [1 1];
P = Polyhedron('V', V, 'R', R);
D = P.dual();
Q = D.dual();
assert(Q==P);

% origin in the interior
V = [-1 -1; -1 1; 1 -1];
R = [1 1];
P = Polyhedron('V', V, 'R', R);
D = P.dual();
Q = D.dual();
assert(Q==P);

% % origin not in the interior
% V = [2 2; 2 3; 3 2];
% R = [1 1];
% P = Polyhedron('V', V, 'R', R);
% D = P.dual();
% Q = D.dual();
% assert(Q<=P);

end
