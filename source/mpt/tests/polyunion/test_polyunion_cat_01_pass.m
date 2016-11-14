function test_polyunion_cat_01_pass
% horizontal and vertical concatenation of unions (issue #88)

P = Polyhedron('lb', -1, 'ub', 1);
VU = PolyUnion([P; P]);
HU = PolyUnion([P, P]);

V = [VU; VU];
H = [VU VU];
Q = [V; HU];
assert(isequal(size(Q), [3 1]));
Q = [V, HU];
assert(isequal(size(Q), [3 1]));
Q = [V; VU];
assert(isequal(size(Q), [3 1]));
Q = [V, VU];
Q = [H; HU];
assert(isequal(size(Q), [3 1]));
Q = [H, HU];
assert(isequal(size(Q), [3 1]));
Q = [H; VU];
assert(isequal(size(Q), [3 1]));
Q = [H, VU];
assert(isequal(size(Q), [3 1]));
assert(isequal(size(Q), [3 1]));
Q = [V; H];
assert(isequal(size(Q), [4 1]));
Q = [V, H];
assert(isequal(size(Q), [4 1]));

V = [VU VU];
H = [HU; HU];
Q = [V; HU];
assert(isequal(size(Q), [3 1]));
Q = [V VU];
assert(isequal(size(Q), [3 1]));
Q = [V; H];
assert(isequal(size(Q), [4 1]));
Q = [V, H];
assert(isequal(size(Q), [4 1]));

% arrays explicitly constructed as rows/columns
clear H V
H([1 2]) = HU;
V([2 1]) = VU;
Q = [HU, H];
assert(isequal(size(Q), [3 1]));
Q = [HU; H];
assert(isequal(size(Q), [3 1]));
Q = [HU, V];
assert(isequal(size(Q), [3 1]));
Q = [HU; V];
assert(isequal(size(Q), [3 1]));
Q = [H, VU];
assert(isequal(size(Q), [3 1]));
Q = [H; VU];
assert(isequal(size(Q), [3 1]));
Q = [H; HU];
assert(isequal(size(Q), [3 1]));
Q = [H, HU];
assert(isequal(size(Q), [3 1]));
Q = [H, V];
assert(isequal(size(Q), [4 1]));
Q = [H, V];
assert(isequal(size(Q), [4 1]));
Q = [V, H];
assert(isequal(size(Q), [4 1]));
Q = [V; H];
assert(isequal(size(Q), [4 1]));
Q = [V; V];
assert(isequal(size(Q), [4 1]));
Q = [H H];
assert(isequal(size(Q), [4 1]));

% empty unions
E = PolyUnion;
Q = [E, E];
assert(isequal(size(Q), [2 1]));
Q = [E, H];
assert(isequal(size(Q), [3 1]));
Q = [H; E];
assert(isequal(size(Q), [3 1]));
Q = [V, E];
assert(isequal(size(Q), [3 1]));
Q = [V; E];
assert(isequal(size(Q), [3 1]));

% empty arguments must be removed
Q = [E; [], VU];
assert(isequal(size(Q), [2 1]));
assert(Q(1).Num==0);
assert(Q(2).Num==2);

% concatenation of incompatible objects must fail
[~, msg] = run_in_caller('[H; 1]');
asserterrmsg(msg, 'Only the objects of the same type can be concatenated.');

% concatenation of incompatible objects must fail
[~, msg] = run_in_caller('[HU; P]');
asserterrmsg(msg, 'Only the objects of the same type can be concatenated.');

end
