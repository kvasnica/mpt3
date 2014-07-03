function test_polyhedron_doesintersect_02_pass
% tests Polyhedron/doesIntersect()

% empty set & R^1 do not intersect
P1 = Polyhedron.emptySet(1);
P2 = Polyhedron.fullSpace(1);
assert(~P1.doesIntersect(P2));
assert(~P1.doesIntersect(P2, 'fully'));
assert(~P2.doesIntersect(P1));
assert(~P2.doesIntersect(P1, 'fully'));

% empty set & empty set do not intersect
P1 = Polyhedron.emptySet(1);
P2 = Polyhedron.emptySet(1);
assert(~P1.doesIntersect(P2));
assert(~P1.doesIntersect(P2, 'fully'));
assert(~P2.doesIntersect(P1));
assert(~P2.doesIntersect(P1, 'fully'));

% R^1 and R^1 do intersect
P1 = Polyhedron.fullSpace(1);
P2 = Polyhedron.fullSpace(1);
assert(P1.doesIntersect(P2));
assert(P1.doesIntersect(P2, 'fully'));
assert(P2.doesIntersect(P1));
assert(P2.doesIntersect(P1, 'fully'));

% two boxes whose interesection is lower dimensional
P1 = Polyhedron([0 0; 0 1; 1 0; 1 1]).minHRep();
P2 = Polyhedron([1 0; 1 1; 2 0; 2 1]).minHRep();
assert(P1.doesIntersect(P2));
assert(~P1.doesIntersect(P2, 'fully'));
assert(P2.doesIntersect(P1));
assert(~P2.doesIntersect(P1, 'fully'));
P1 = Polyhedron([0 0; 0 1; 1 0; 1 1]); % V-rep
P2 = Polyhedron([1 0; 1 1; 2 0; 2 1]);
assert(P1.doesIntersect(P2));
assert(~P1.doesIntersect(P2, 'fully'));
assert(P2.doesIntersect(P1));
assert(~P2.doesIntersect(P1, 'fully'));

% two boxes whose interesection is a single vertex
P1 = Polyhedron([0 0; 0 1; 1 0; 1 1]).minHRep();
P2 = Polyhedron([1 1; 2 1; 2 2; 1 2]).minHRep();
assert(P1.doesIntersect(P2));
assert(~P1.doesIntersect(P2, 'fully'));
assert(P2.doesIntersect(P1));
assert(~P2.doesIntersect(P1, 'fully'));
P1 = Polyhedron([0 0; 0 1; 1 0; 1 1]);
P2 = Polyhedron([1 1; 2 1; 2 2; 1 2]);
assert(P1.doesIntersect(P2));
assert(~P1.doesIntersect(P2, 'fully'));
assert(P2.doesIntersect(P1));
assert(~P2.doesIntersect(P1, 'fully'));

% two polyhedra whose bounding boxes do not overlap => no intersection
P1 = Polyhedron([0 0; 0 1; 1 0; 1 1]).minHRep();
P2 = Polyhedron([2 0; 2 1; 3 0; 3 1]).minHRep();
assert(~P1.doesIntersect(P2));
assert(~P1.doesIntersect(P2, 'fully'));
assert(~P2.doesIntersect(P1));
assert(~P2.doesIntersect(P1, 'fully'));
P1 = Polyhedron([0 0; 0 1; 1 0; 1 1]);
P2 = Polyhedron([2 0; 2 1; 3 0; 3 1]);
assert(~P1.doesIntersect(P2));
assert(~P1.doesIntersect(P2, 'fully'));
assert(~P2.doesIntersect(P1));
assert(~P2.doesIntersect(P1, 'fully'));

% two polyhedra whose bounding boxes overlap, but intersection is empty
P1 = Polyhedron([0 0; 0 5; 5 5]).minHRep();
P2 = Polyhedron([2 1; 2.5 1; 2 1.5; 2.5 1.5]).minHRep();
assert(~P1.doesIntersect(P2));
assert(~P1.doesIntersect(P2, 'fully'));
assert(~P2.doesIntersect(P1));
assert(~P2.doesIntersect(P1, 'fully'));
P1 = Polyhedron([0 0; 0 5; 5 5]);
P2 = Polyhedron([2 1; 2.5 1; 2 1.5; 2.5 1.5]);
assert(~P1.doesIntersect(P2));
assert(~P1.doesIntersect(P2, 'fully'));
assert(~P2.doesIntersect(P1));
assert(~P2.doesIntersect(P1, 'fully'));

% two polyhedra whose bounding boxes overlap, but intersection is
% lower-dimensional
P1 = Polyhedron([0 0; 0 5; 5 5]).minHRep();
P2 = Polyhedron([2 2; 2.5 2; 2.5 2.5]).minHRep();
assert(P1.doesIntersect(P2));
assert(~P1.doesIntersect(P2, 'fully'));
assert(P2.doesIntersect(P1));
assert(~P2.doesIntersect(P1, 'fully'));
P1 = Polyhedron([0 0; 0 5; 5 5]);
P2 = Polyhedron([2 2; 2.5 2; 2.5 2.5]);
assert(P1.doesIntersect(P2));
assert(~P1.doesIntersect(P2, 'fully'));
assert(P2.doesIntersect(P1));
assert(~P2.doesIntersect(P1, 'fully'));

% two polyhedra whose bounding boxes overlap and the intersection is
% full-dimensional
P1 = Polyhedron([0 0; 0 5; 5 5]).minHRep();
P2 = Polyhedron([2 2; 2.5 2; 2.5 2.5; 2 2.5]).minHRep();
assert(P1.doesIntersect(P2));
assert(P1.doesIntersect(P2, 'fully'));
assert(P2.doesIntersect(P1));
assert(P2.doesIntersect(P1, 'fully'));
P1 = Polyhedron([0 0; 0 5; 5 5]);
P2 = Polyhedron([2 2; 2.5 2; 2.5 2.5; 2 2.5]);
assert(P1.doesIntersect(P2));
assert(P1.doesIntersect(P2, 'fully'));
assert(P2.doesIntersect(P1));
assert(P2.doesIntersect(P1, 'fully'));

end
