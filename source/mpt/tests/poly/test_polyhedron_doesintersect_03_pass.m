function test_polyhedron_doesintersect_03_pass
% tests intersection of lower-dimensional sets

% P1 low-dim, intersections exists
P1 = Polyhedron([0 0; 1 1]);
P2 = Polyhedron.unitBox(2);
assert(P1.doesIntersect(P2));
assert(~P1.doesIntersect(P2, 'fully'));
assert(P2.doesIntersect(P1));
assert(~P2.doesIntersect(P1, 'fully'));

% P1 low-dim, intersections exists
P1 = Polyhedron([1 1; 2 2]);
P2 = Polyhedron.unitBox(2);
assert(P1.doesIntersect(P2));
assert(~P1.doesIntersect(P2, 'fully'));
assert(P2.doesIntersect(P1));
assert(~P2.doesIntersect(P1, 'fully'));

% P1 low-dim, not intersection
P1 = Polyhedron([2 2; 3 3]);
P2 = Polyhedron.unitBox(2);
assert(~P1.doesIntersect(P2));
assert(~P1.doesIntersect(P2, 'fully'));
assert(~P2.doesIntersect(P1));
assert(~P2.doesIntersect(P1, 'fully'));

% P1 and P2 lowdim, intersection exists
P1 = Polyhedron([0 0; 1 1]);
P2 = Polyhedron([0 1; 1 0]);
assert(P1.doesIntersect(P2));
assert(~P1.doesIntersect(P2, 'fully'));

% P1 and P2 lowdim, intersection exists
P1 = Polyhedron([0 0; 1 1]);
P2 = Polyhedron([1 1; 2 2]);
assert(P1.doesIntersect(P2));
assert(~P1.doesIntersect(P2, 'fully'));

% P1 and P2 lowdim, intersection exists
P1 = Polyhedron([0 0; 1 1]);
P2 = Polyhedron([0.5 0.5; 2 2]);
assert(P1.doesIntersect(P2));
assert(~P1.doesIntersect(P2, 'fully'));

% P1 and P2 lowdim, no intersection
P1 = Polyhedron([0 0; 0.5 0.5]);
P2 = Polyhedron([1 1; 2 2]);
assert(~P1.doesIntersect(P2));
assert(~P1.doesIntersect(P2, 'fully'));

% P1 and P2 lowdim, no intersection
P1 = Polyhedron([0 0; 1 1]);
P2 = Polyhedron([0.5 0; 1 0.5]);
assert(~P1.doesIntersect(P2));
assert(~P1.doesIntersect(P2, 'fully'));

end
