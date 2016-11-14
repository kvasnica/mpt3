function test_union_contains_04_pass
%
% arrays of unions must be rejected
%

Z = Polyhedron('lb', -1, 'ub', 1);
Y1 = Polyhedron('lb', -0.5, 'ub', 1);
Y2 = Polyhedron('lb', 0, 'ub', 2);
U1 = Union([Y1 Y2]);
U2 = Union(Z);
U = [U1 U2];
x = 1;

% no direct operation on arrays
[~, msg] = run_in_caller('U.contains(x);');
asserterrmsg(msg, 'This method does not support arrays.');

% per-element evaluation must work

% x in U2
x = -1;
isin = U.forEach(@(e) e.contains(x));
assert(isequal(isin, [false true]));
% non-scalar outputs
[~, msg] = run_in_caller('[isin, inwhich] = U.forEach(@(e) e.contains(x));');
asserterrmsg(msg, 'Non-scalar in Uniform output, at index 1, output 2.');
[isin, inwhich] = U.forEach(@(e) e.contains(x), 'UniformOutput', false);
assert(iscell(isin));
assert(numel(isin)==2);
assert(~isin{1});
assert(isin{2});
assert(iscell(inwhich));
assert(numel(inwhich)==2);
assert(isempty(inwhich{1}));
assert(inwhich{2}==1);
[isin, inwhich, closest] = U.forEach(@(e) e.contains(x), 'UniformOutput', false);
assert(iscell(isin));
assert(numel(isin)==2);
assert(~isin{1});
assert(isin{2});
assert(iscell(inwhich));
assert(numel(inwhich)==2);
assert(isempty(inwhich{1}));
assert(inwhich{2}==1);
assert(closest{1}==1);
assert(isempty(closest{2}));

% x in U1
x = 2;
isin = U.forEach(@(e) e.contains(x));
assert(isequal(isin, [true false]));

% x in both
x = 0.1;
isin = U.forEach(@(e) e.contains(x));
assert(isequal(isin, [true true]));
[~, msg] = run_in_caller('[isin, inwhich] = U.forEach(@(e) e.contains(x));');
asserterrmsg(msg, 'Non-scalar in Uniform output, at index 1, output 2.');
[isin, inwhich] = U.forEach(@(e) e.contains(x), 'UniformOutput', false);
assert(isin{1});
assert(isin{2});
assert(isequal(inwhich{1}, [1 2]));
assert(inwhich{2}==1);

end
