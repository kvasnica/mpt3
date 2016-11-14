function test_polytope_01_pass
% tests that empty polytopes are correctly returned

% the set { x | 0 <= x <= -1 } is empty
p = polytope([1; -1], [-1; 0]);
T = evalc('p');
assert(~isempty(findstr(T, 'Empty polyhedron in R^0')));

% the set { x | 0 <= x <= 1 } is not empty
p = polytope([1; -1], [1; 0]);
T = evalc('p');
assert(~isempty(findstr(T, 'Polyhedron in R^1 with representations')));

% check that we automatically perform redundancy elimination
assert(~isempty(findstr(T, 'H-rep (irredundant)')));

end
