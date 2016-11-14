function test_polyhedron_48_pass
% V-rep of an unpointed half-space fails (related to issues #75 and #94)

% x>=y should give rays [1 1; -1 -1; 1 -1]
P1=Polyhedron([-1 1], 0);
R = [1 1; -1 -1; 1 -1];
V = [0 0];
assert(size(P1.V, 1)==1); % must get 1 vertex
assert(size(P1.R, 1)==3); % must get 3 rays
assert(norm(sortrows(P1.R)-sortrows(R)) < 1e-10);
assert(norm(sortrows(P1.V)-sortrows(V)) < 1e-10);

% x>=y+1 should give the same rays and the vertex [1; 0]
P1=Polyhedron([-1 1], -1);
R = [1 1; -1 -1; 1 -1];
V = [1 0];
assert(size(P1.V, 1)==1); % must get 1 vertex
assert(size(P1.R, 1)==3); % must get 3 rays
assert(norm(sortrows(P1.R)-sortrows(R)) < 1e-10);
assert(norm(sortrows(P1.V)-sortrows(V)) < 1e-10);

end
