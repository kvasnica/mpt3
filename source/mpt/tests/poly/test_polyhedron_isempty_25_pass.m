function test_polyhedron_isempty_25_pass
% trivially empty set (issue #79)

% the set A*x<=b is empty due to the first constraint
A = [0; -1; 0; 1]; 
b = [-9; 1; 1; 1];

P = Polyhedron('A', A, 'b', b);
assert(P.isEmptySet);

P = Polyhedron(A, b);
assert(P.isEmptySet);

end
