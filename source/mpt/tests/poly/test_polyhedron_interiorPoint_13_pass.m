function test_polyhedron_interiorPoint_13_pass
% interior point of a polyhedron that consists only of rays

P = Polyhedron('R',[0 0 1;0.1 0.2 0.3]);
x = P.interiorPoint();
assert(~isempty(x.x));
assert(isequal(size(x.x), [3 1]));
assert(~x.isStrict);

% this is the same polyhedron as above, but in H-rep
R = Polyhedron('H',[ -1 0  0 0; 3 0 -1 0],'He',[2 -1 0 0]);
x = R.interiorPoint();
assert(~isempty(x.x));
assert(isequal(size(x.x), [3 1]));
assert(~x.isStrict);

end
