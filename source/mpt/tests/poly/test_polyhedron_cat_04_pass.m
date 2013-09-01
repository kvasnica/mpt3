function test_polyhedron_cat_04_pass
% vertcat and horzcat should be the same

V = [Polyhedron; Polyhedron];
H = [Polyhedron Polyhedron];
P = Polyhedron;

% all these should work and produce a column array
Q = [P, H];
assert(isequal(size(Q), [3 1]));
Q = [P; H];
assert(isequal(size(Q), [3 1]));
Q = [P, V];
assert(isequal(size(Q), [3 1]));
Q = [P; V];
assert(isequal(size(Q), [3 1]));
Q = [H, P];
assert(isequal(size(Q), [3 1]));
Q = [H; P];
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

% arrays explicitly constructed as rows/columns
clear H V
H([1 2]) = Polyhedron;
V([2 1]) = Polyhedron;
Q = [P, H];
assert(isequal(size(Q), [3 1]));
Q = [P; H];
assert(isequal(size(Q), [3 1]));
Q = [P, V];
assert(isequal(size(Q), [3 1]));
Q = [P; V];
assert(isequal(size(Q), [3 1]));
Q = [H, P];
assert(isequal(size(Q), [3 1]));
Q = [H; P];
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

end
