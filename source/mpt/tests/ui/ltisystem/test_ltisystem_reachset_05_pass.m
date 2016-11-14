function test_ltisystem_reachset_05_pass
% tests error messages in LTISystem/reachableSet

model = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
model.x.min = [-5; -5];
model.x.max = [5; 5];
model.u.min = -1;
model.u.max = 1;

% X must be a polyhedron
X = 1;
[worked, msg] = run_in_caller('model.reachableSet(''X'', X);');
assert(~worked);
assert(~isempty(strfind(msg, 'Input argument must be a "Polyhedron" class.')));

% U must be a polyhedron
U = 1;
[worked, msg] = run_in_caller('model.reachableSet(''U'', U);');
assert(~worked);
assert(~isempty(strfind(msg, 'Input argument must be a "Polyhedron" class.')));

% U must not be empty
P = Polyhedron([1; -1], [-1; 0]);
[worked, msg] = run_in_caller('model.reachableSet(''U'', P);');
assert(~worked);
assert(~isempty(strfind(msg, 'Input constraints must not be empty.')));

% X must have correct dimension
P = Polyhedron([1; -1], [1; 0]);
[worked, msg] = run_in_caller('model.reachableSet(''X'', P);');
assert(~worked);
assert(~isempty(strfind(msg, 'State constraints must be a polyhedron in 2D.')));

% U must have correct dimension
P = Polyhedron([1 0; -1 0], [1; 0]);
[worked, msg] = run_in_caller('model.reachableSet(''U'', P);');
assert(~worked);
assert(~isempty(strfind(msg, 'Input constraints must be a polyhedron in 1D.')));

end
