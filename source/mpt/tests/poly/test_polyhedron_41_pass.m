function test_polyhedron_41_pass
% trivially infeasible rows must not be silently removed (issue #79)

% the set A*x<=b is empty due to the first constraint
A = [0; -1; 0; 1]; 
b = [-9; 1; 1; 1];

P = Polyhedron(A, b);

assert(P.isEmptySet());

% the H-representation should be left intact
assert(isequal(P.H, [A, b]));

P = Polyhedron(A, b);
assert(isequal(P.H, [A, b]));

P = Polyhedron('A', A, 'b', b);
assert(isequal(P.H, [A, b]));

end
