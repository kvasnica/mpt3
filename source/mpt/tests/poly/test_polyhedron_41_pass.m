function test_polyhedron_41_pass
% trivially infeasible rows must not be silently removed (issue #79)

% the set A*x<=b is empty due to the first constraint
A = [0; -1; 0; 1]; 
b = [-9; 1; 1; 1];

% the zero row 0*x<=-9 must stay!
expected = [-1 1;0 -9;1 1];

P = Polyhedron(A, b);
assert(isequal(sortrows(P.H), expected));

P = Polyhedron('A', A, 'b', b);
assert(isequal(sortrows(P.H), expected));

end
