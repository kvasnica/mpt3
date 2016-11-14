function test_polyhedron_setdiff_27_pass
%
% tests error message when supplying polyhedra in different dimensions

P1 = Polyhedron('lb', -1, 'ub', 1);
P2 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);

[worked, msg] = run_in_caller('R = P1\P2');
assert(~worked);
assert(~isempty(strfind(msg, 'All polyhedra must be in the same dimension.')));

[worked, msg] = run_in_caller('R = P2\P1');
assert(~worked);
assert(~isempty(strfind(msg, 'All polyhedra must be in the same dimension.')));

[worked, msg] = run_in_caller('R = P2\[P1 P2]');
assert(~worked);
assert(~isempty(strfind(msg, 'All polyhedra must be in the same dimension.')));

[worked, msg] = run_in_caller('R = [P2 P1]\[P1 P2]');
assert(~worked);
assert(~isempty(strfind(msg, 'All polyhedra must be in the same dimension.')));

[worked, msg] = run_in_caller('R = [P2 P1]\P2');
assert(~worked);
assert(~isempty(strfind(msg, 'All polyhedra must be in the same dimension.')));
