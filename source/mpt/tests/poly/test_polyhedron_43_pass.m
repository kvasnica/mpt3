function test_polyhedron_43_pass
% vertex/ray enumeration of unbounded polyhedra (issue #94)

% unbounded half-space
P = Polyhedron([1 0], 0);
Rexpected = [1 0; 0 1; 0 -1];
%assert(isempty(P.V)); % no vertices
assert(isequal(sortrows(P.R), sortrows(Rexpected)));

% unbounded half-space
P = Polyhedron([1 0], 1);
Rexpected = [1 0; 0 1; 0 -1];
Vexpected = [1 0];
assert(isequal(P.V, Vexpected));
assert(isequal(sortrows(P.R), sortrows(Rexpected)));

end
