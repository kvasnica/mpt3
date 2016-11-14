function test_polyhedron_slice_03_pass
%
% keepDim=true
% 

%% single polyhedron

% fulldim
P = Polyhedron([-1 0; 1 3; 1 -1; 2 0]);
S = P.slice(1, 0, 'keepDim', true);
Sgood = Polyhedron([0 -0.5; 0 1.5]);
assert(S==Sgood);
assert(S.Dim==P.Dim);

S = P.slice(1, 1, 'keepDim', true);
Sgood = Polyhedron([1 -1; 1 3]);
assert(S==Sgood);

S = P.slice(1, 10, 'keepDim', true);
assert(S.isEmptySet);

S = P.slice(2, 0, 'keepDim', true);
Sgood = Polyhedron([-1 0; 2 0]);
assert(S==Sgood);

S = P.slice(2, 1.5, 'keepDim', true);
Sgood = Polyhedron([0 1.5; 1.5 1.5]);
assert(S==Sgood);

S = P.slice(2, 10, 'keepDim', true);
assert(S.isEmptySet);

% 3D lowdim
P = Polyhedron([-1 0 0.1; 1 3 0.1; 1 -1 0.1; 2 0 0.1]);

S = P.slice(3, 0, 'keepDim', true);
assert(S.isEmptySet);
assert(S.Dim==P.Dim);

S = P.slice(3, 0.1, 'keepDim', true);
assert(S==P);

S = P.slice(1, -0.5, 'keepDim', true);
Sgood = Polyhedron([-0.5 -0.25 0.1;-0.5 0.75 0.1]);
assert(S==Sgood);
assert(S.Dim==P.Dim);

S = P.slice([1 3], [-0.5 0.1], 'keepDim', true);
Sgood = Polyhedron([-0.5 -0.25 0.1;-0.5 0.75 0.1]);
assert(S==Sgood);

S = P.slice([1 2], [1 2], 'keepDim', true); % single vertex
assert(isequal(S.V, [1, 2, 0.1]));

%% array of polyhedra
P1 = Polyhedron([-1 0; 1 3; 1 -1; 2 0]); % 2D fulldim
P2 = Polyhedron([-1 0 0.1; 1 3 0.1; 1 -1 0.1; 2 0 0.1]); % 3D lowdim
P = [P1 P2];

S = P.slice(1, -0.5, 'keepDim', true);
S1good = Polyhedron([-0.5 -0.25;-0.5 0.75]);
S2good = Polyhedron([-0.5 -0.25 0.1;-0.5 0.75 0.1]);
assert(isa(S, 'Polyhedron'));
assert(numel(S)==2);
assert(S(1)==S1good);
assert(S(2)==S2good);

end
