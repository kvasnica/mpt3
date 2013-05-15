function test_filter_terminalSet_02_pass
% tests SystemSignal/filter_terminalSet

u = SystemSignal(1);
u.userData.kind = 'u';
[worked, msg] = run_in_caller('u.with(''terminalSet'');');
assert(~worked);
assert(~isempty(strfind(msg, 'Filter "terminalSet" can only be added to state variables.')));

% add the filter
x = SystemSignal(3);
x.userData.kind = 'x';
x.with('terminalSet');

% the set must be a polyhedron
P = eye(x.n);
[worked, msg] = run_in_caller('x.terminalSet=P;');
assert(~worked);
assert(~isempty(strfind(msg, 'The input must be a polyhedron.')));

% the set must be a single polyhedron
P = Polyhedron('lb', -ones(x.n, 1), 'ub', ones(x.n, 1));
[worked, msg] = run_in_caller('x.terminalSet=[P P];');
assert(~worked);
assert(~isempty(strfind(msg, 'The input must be a single polyhedron.')));

% the set must be in correct dimension
P = Polyhedron('lb', -ones(x.n+1, 1), 'ub', ones(x.n+1, 1));
[worked, msg] = run_in_caller('x.terminalSet=P;');
assert(~worked);
assert(~isempty(strfind(msg, sprintf('The polyhedron must be in dimension %d.', x.n))));

% the set must not be empty
P = Polyhedron('A', [1 0 0; -1 0 0], 'b', [1; -2]);
[worked, msg] = run_in_caller('x.terminalSet=P;');
assert(~worked);
assert(~isempty(strfind(msg, 'The polyhedron must not be empty.')));

end
