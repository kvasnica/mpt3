function test_polyhedron_normalize_08_pass
% if there are zero rows, the remaining ones should still be normalized

H = [0 0 0;...
	0 2 3; ...
	0 0 2; ...
	0 0 -2];
Hexpected = [0 0 0; ...
	0 1 1.5; ...
	0 0 1; ...
	0 0 -1];

% faster constructor
P = Polyhedron(H(:, 1:end-1), H(:, end));
assert(isequal(P.H, H));
P.normalize();
assert(isequal(P.H, Hexpected));

% full constructor
P = Polyhedron('A', H(:, 1:end-1), 'b', H(:, end));
assert(isequal(P.H, H));
P.normalize();
assert(isequal(P.H, Hexpected));

P = Polyhedron('H', H);
assert(isequal(P.H, H));
P.normalize();
assert(isequal(P.H, Hexpected));

end
