function test_polyhedron_47_pass
% H-rep of R^n must be correct

% R^1
d = 1;
P = Polyhedron('V', zeros(1, d), 'R', [eye(d); -eye(d)]);
assert(isequal(P.H, [zeros(1, d) 1]));
assert(isempty(P.He));

% R^3
d = 3;
P = Polyhedron('V', zeros(1, d), 'R', [eye(d); -eye(d)]);
assert(isequal(P.H, [zeros(1, d) 1]));
assert(isempty(P.He));


end
