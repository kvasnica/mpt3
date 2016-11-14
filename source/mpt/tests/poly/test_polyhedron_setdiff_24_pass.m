function test_polyhedron_setdiff_24_pass
%
% set difference between a lower and full dimensional polytopes
%

% facet \ cube = empty set
P1 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]).minHRep();
V2 = [1 -1; 1 1];
P2 = Polyhedron(V2).minHRep();
R = P2\P1;
assert(isa(R, 'Polyhedron'));
assert(R.Dim==2);
assert(R.isEmptySet());

% subset of a facet \ cube = empty set
P1 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]).minHRep();
V2 = [1 -0.5; 1 0.5];
P2 = Polyhedron(V2).minHRep();
R = P2\P1;
assert(isa(R, 'Polyhedron'));
assert(R.Dim==2);
assert(R.isEmptySet());

% superset of a facet \ cube = two lower-dimensional sets
P1 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]).minHRep();
V2 = [1 -2; 1 2];
P2 = Polyhedron(V2).minHRep();
R = P2\P1;
D1 = Polyhedron([1 -2; 1 -1]).minHRep();
D2 = Polyhedron([1 1; 1 2]).minHRep();
assert(numel(R)==2);
assert( (R(1)==D1 && R(2)==D2) || (R(1)==D2 && R(2)==D1) );

% valid inequality \ cube = valid inequality
P1 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]).minHRep();
V2 = [2 -1; 2 1];
P2 = Polyhedron(V2).minHRep();
R = P2\P1;
assert(numel(R)==1);
assert(R==P2);

% intersecting plane \ cube = two lower-dimensional sets
P1 = Polyhedron('lb', [-0.5; -0.5], 'ub', [0.5; 0.5]);
P2 = Polyhedron([0 -1; 0 1]);
R = P2\P1;
D1 = Polyhedron([0 -0.5; 0 -1]).minHRep();
D2 = Polyhedron([0 0.5; 0 1]).minHRep();
assert(numel(R)==2);
assert( (R(1)==D1 && R(2)==D2) || (R(1)==D2 && R(2)==D1) );

% 3D plane \ 3D cube = two 3D planes
P1 = Polyhedron([-1 -1 0; -1 1 0; 1 1 0; 1 -1 0]).minHRep();
P2 = Polyhedron('lb', [0; 0; -2], 'ub', [2; 2; 2]).minHRep();
R = P1\P2;
D1 = Polyhedron('H', [1 0 0 0;-0 -1 -0 1;-1 -0 -0 1;-0 1 -0 1], 'He', [-0 -0 -1 0]);
D2 = Polyhedron('H', [0 1 0 0;-1 -0 -0 -0;-0 -1 -0 1;1 -0 -0 1], 'He', [-0 -0 -1 0]);
assert(numel(R)==2);
assert(R(1).Dim==3);
assert(R(2).Dim==3);
assert( (R(1)==D1 && R(2)==D2) || (R(1)==D2 && R(2)==D1) );

% tilted 3D plane \ 3D cube = four 3D planes
P1 = Polyhedron([-1 -1 0; -1 3 0; 1 3 3; 1 -1 3]).minHRep();
P2 = Polyhedron('lb', [0; 0; -2], 'ub', [2; 2; 2]).minHRep();
R = P1\P2;
assert(numel(R)==4);
for i = 1:4
	assert(~R(i).intersect(P2).isFullDim());
end

end
