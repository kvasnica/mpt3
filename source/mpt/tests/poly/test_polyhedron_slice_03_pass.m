function test_polyhedron_slice_03_pass
%
% array of polyhedra
% 

P1 = Polyhedron([-1 0; 1 3; 1 -1; 2 0]); % 2D fulldim
P2 = Polyhedron([-1 0 0.1; 1 3 0.1; 1 -1 0.1; 2 0 0.1]); % 3D lowdim
P = [P1 P2];

S = P.slice(1, -0.5);
S1good = Polyhedron([-0.5 -0.25;-0.5 0.75]);
S2good = Polyhedron([-0.5 -0.25 0.1;-0.5 0.75 0.1]);
assert(isa(S, 'Polyhedron'));
assert(numel(S)==2);
assert(S(1)==S1good);
assert(S(2)==S2good);

end
