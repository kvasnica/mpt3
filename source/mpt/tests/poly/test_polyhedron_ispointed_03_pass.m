function test_polyhedron_ispointed_03_pass
% testing arrays of polyhedra

% a slab -1 <= x(1) <= 1, x(2) arbitrary, is not pointed
V = [-1 0; 1 0];
R = [0 1; 0 -1];
P = Polyhedron('V', V, 'R', R);
% polyhedron -1 <= x(1) <= 1, x(2)>=0 is pointed
V = [-1 0; 1 0];
R = [0 1];
Q = Polyhedron('V', V, 'R', R);

A = [P, Q];
assert(numel(A)==2);
assert(~A(1).isPointed());
assert(A(2).isPointed());

answer = A.isPointed();
assert(numel(answer)==numel(A));
assert(~answer(1));
assert(answer(2));

end
