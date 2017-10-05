function test_polyhedron_setdiff_26_pass
%
% set difference between two lower-dimensional polytopes

% two vertices in 1D
P1 = Polyhedron('H', [1 -1; -1 1]);
P2 = Polyhedron('H', [1 -1; -1 1]);
R = P1\P2;
assert(numel(R)==1);
assert(R.isEmptySet());

% two parallel 2D lines without intersection
P1 = Polyhedron([1 1; 2 1]).minHRep();
P2 = Polyhedron([0.5 2; 1.75 2]).minHRep();
R = P1\P2;
assert(numel(R)==1);
assert(R==P1);

% two non-parallel 2D lines intersecting at one point
P1 = Polyhedron([0 0; 2 2]).minHRep();
P2 = Polyhedron([0 0.5; 1.75 0.5]).minHRep();
R = P1\P2;
assert(numel(R)==1);
assert(R==P1);

% 2D(line) \ 2D(line) = two 2D line segments
P1 = Polyhedron([1 1; 2 1]).minHRep();
P2 = Polyhedron([1.25 1; 1.75 1]).minHRep();
R = P1\P2;
D1 = Polyhedron([1 1; 1.25 1]).minHRep();
D2 = Polyhedron([1.75 1; 2 1]).minHRep();
assert(numel(R)==2);
assert(R(1).Dim==2);
assert(R(2).Dim==2);
assert( (R(1)==D1 && R(2)==D2) || (R(1)==D2 && R(2)==D1) );

% 3D(planar) \ 3D(planar)
P1 = Polyhedron([0 0 0; 1 0 0; 0 1 0; 1 1 0]);
P2 = Polyhedron([0.25 0.25 0; 0.75 0.25 0; 0.75 0.75 0; 0.25 0.75 0]);
R = P1\P2;
assert(numel(R)==4);
D1 = Polyhedron([1 0 0;0 0 0;0 0.25 0;1 0.25 0]).minHRep();
D2 = Polyhedron([0 0.25 0;0.25 0.25 0;0.25 1 0;0 1 0]).minHRep();
D3 = Polyhedron([0.25 0.75 0;1 0.75 0;1 1 0;0.25 1 0]).minHRep();
D4 = Polyhedron([0.75 0.25 0;1 0.25 0;1 0.75 0;0.75 0.75 0]).minHRep();
D = [D1 D2 D3 D4];
p_eq = zeros(4);
for i = 1:4
	assert(R(i).Dim==3);
	for j = i:4
		p_eq(i, j) = (R(i)==D(j));
	end
end
assert(sum(sum(p_eq, 1))==4);
assert(sum(sum(p_eq, 2))==4);

% 3D(planar) \ 3D(line)
P1 = Polyhedron([0 0 0; 1 0 0; 0 1 0; 1 1 0]);
P2 = Polyhedron([0.5 -1 0; 0.5 2 0]);
R = P1\P2;
assert(numel(R)==1);
assert(R==P1);

% 3D(line) \ 3D(planar) = two 3D line segments
P1 = Polyhedron([0.5 -1 0; 0.5 2 0]);
P2 = Polyhedron([0 0 0; 1 0 0; 0 1 0; 1 1 0]);
R = P1\P2;
D1 = Polyhedron('H', [0 1 0 0;0 -1 0 1], 'He', [-1 0 0 -0.5; 0 0 -1 0]);
D2 = Polyhedron('H', [0 1 0 2;0 -1 0 -1], 'He', [-1 0 0 -0.5; 0 0 -1 0]);
assert(numel(R)==2);
assert( (R(1)==D1 && R(2)==D2) || (R(1)==D2 && R(2)==D1) );

end
