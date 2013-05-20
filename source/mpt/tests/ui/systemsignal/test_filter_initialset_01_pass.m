function test_filter_initialset_01_pass

x = SystemSignal(2);
x.userData.kind = 'x';

% the filter should not be active by default
assert(~x.hasFilter('initialSet'));

% add the filter
x.with('initialSet');
assert(x.hasFilter('initialSet'));

% the set must be a polyhedron
[worked, msg] = run_in_caller('x.initialSet = 1');
assert(~worked);
assert(~isempty(strfind(msg, 'The input must be a polyhedron.')));

% the set must be of compatible dimension
P = Polyhedron('lb', [-1;-1;-1], 'ub', [1;1;1]);
[worked, msg] = run_in_caller('x.initialSet = P;');
assert(~worked);
assert(~isempty(strfind(msg, 'The polyhedron must be in dimension 2.')));

% the set must not be empty
P = Polyhedron([eye(2); -eye(2)], [-1; -1; 0; 0]);
assert(P.isEmptySet);
[worked, msg] = run_in_caller('x.initialSet = P;');
assert(~worked);
assert(~isempty(strfind(msg, 'The polyhedron must not be empty.')));

% the set must be a single polyhedron
P1 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
P2 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
[worked, msg] = run_in_caller('x.initialSet = [P1 P2];');
assert(~worked);
assert(~isempty(strfind(msg, 'The input must be a single polyhedron.')));

% finally a correct set
P = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
x.initialSet = P;
Q = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
assert(x.initialSet == Q);

end
