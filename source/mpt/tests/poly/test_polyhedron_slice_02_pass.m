function test_polyhedron_slice_02_pass
%
% keepDim=false
% 

%% single polyhedron

% fulldim
P = Polyhedron([-1 0; 1 3; 1 -1; 2 0]);
S = P.slice(1);
Sgood = Polyhedron([-0.5; 1.5]);
assert(S==Sgood);
assert(S.Dim==1);

S = P.slice(1, 1);
Sgood = Polyhedron([-1; 3]);
assert(S==Sgood);

S = P.slice(1, 10);
assert(S.isEmptySet);

S = P.slice(2);
Sgood = Polyhedron([-1; 2]);
assert(S==Sgood);

S = P.slice(2, 1.5);
Sgood = Polyhedron([0; 1.5]);
assert(S==Sgood);

S = P.slice(2, 10);
assert(S.isEmptySet);

% 3D lowdim
P = Polyhedron([-1 0 0.1; 1 3 0.1; 1 -1 0.1; 2 0 0.1]);

S = P.slice(3);
assert(S.isEmptySet);
assert(S.Dim==2);

S = P.slice(3, 0.1);
assert(S==Polyhedron([-1 0; 1 3; 1 -1; 2 0]));

S = P.slice(1, -0.5);
Sgood = Polyhedron([-0.25 0.1; 0.75 0.1]);
assert(S==Sgood);
assert(S.Dim==2);

S = P.slice([1 3], [-0.5 0.1]);
Sgood = Polyhedron([-0.25; 0.75]);
assert(S==Sgood);
assert(S.Dim==1);

S = P.slice([1 2], [1 2]); % single vertex
assert(isequal(S.V, [0.1]));
assert(S.Dim==1);

%% array of polyhedra
P1 = Polyhedron([-1 0; 1 3; 1 -1; 2 0]); % 2D fulldim
P2 = Polyhedron([-1 0 0.1; 1 3 0.1; 1 -1 0.1; 2 0 0.1]); % 3D lowdim
P = [P1 P2];

S = P.slice(1, -0.5);
S1good = Polyhedron([-0.25; 0.75]);
S2good = Polyhedron([-0.25 0.1; 0.75 0.1]);
assert(isa(S, 'Polyhedron'));
assert(numel(S)==2);
assert(S(1)==S1good);
assert(S(2)==S2good);

end
