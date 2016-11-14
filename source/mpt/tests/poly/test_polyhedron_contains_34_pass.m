function test_polyhedron_contains_34_pass
% interior point of a polyhedron that consists only of rays must be
% contained in the polyhedron

P = Polyhedron('R',[0 0 1;0.1 0.2 0.3]);
x = P.interiorPoint();
assert(~isempty(x.x));
assert(P.contains(x.x));

% this is the same polyhedron as above, but in H-rep
P = Polyhedron('H',[ -1 0  0 0; 3 0 -1 0],'He',[2 -1 0 0]);
x = P.interiorPoint();
assert(~isempty(x.x));
assert(P.contains(x.x));

end
