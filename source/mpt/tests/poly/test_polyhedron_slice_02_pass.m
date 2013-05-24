function test_polyhedron_slice_02_pass
%
% single polyhedron
% 

% fulldim
P = Polyhedron([-1 0; 1 3; 1 -1; 2 0]);
S = P.slice(1);
Sgood = Polyhedron([0 -0.5; 0 1.5]);
assert(S==Sgood);
assert(S.Dim==P.Dim);

S = P.slice(1, 1);
Sgood = Polyhedron([1 -1; 1 3]);
assert(S==Sgood);

S = P.slice(1, 10);
assert(S.isEmptySet);

S = P.slice(2);
Sgood = Polyhedron([-1 0; 2 0]);
assert(S==Sgood);

S = P.slice(2, 1.5);
Sgood = Polyhedron([0 1.5; 1.5 1.5]);
assert(S==Sgood);

S = P.slice(2, 10);
assert(S.isEmptySet);

% 3D lowdim
P = Polyhedron([-1 0 0.1; 1 3 0.1; 1 -1 0.1; 2 0 0.1]);

S = P.slice(3);
assert(S.isEmptySet);
assert(S.Dim==P.Dim);

S = P.slice(3, 0.1);
assert(S==P);

S = P.slice(1, -0.5);
Sgood = Polyhedron([-0.5 -0.25 0.1;-0.5 0.75 0.1]);
assert(S==Sgood);
assert(S.Dim==P.Dim);

S = P.slice([1 3], [-0.5 0.1]);
Sgood = Polyhedron([-0.5 -0.25 0.1;-0.5 0.75 0.1]);
assert(S==Sgood);

S = P.slice([1 2], [1 2]); % single vertex
assert(isequal(S.V, [1, 2, 0.1]));

end
