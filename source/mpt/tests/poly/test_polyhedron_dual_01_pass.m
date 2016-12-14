function test_polyhedron_dual_01_pass
% tests Polyhedron/dual for R^n and empty sets

% dual of an empty set is R^n
P = Polyhedron.emptySet(1);
R = P.dual();
assert(R.isFullSpace());
assert(R.Dim==P.Dim);
P = Polyhedron.emptySet(3);
R = P.dual();
assert(R.isFullSpace());
assert(R.Dim==P.Dim);

% dual of R^n is an empty set
P = Polyhedron.fullSpace(1);
R = P.dual();
assert(R.isEmptySet());
assert(R.Dim==P.Dim);
P = Polyhedron.fullSpace(3);
R = P.dual();
assert(R.isEmptySet());
assert(R.Dim==P.Dim);
P = Polyhedron('R', [eye(2); -eye(2)]);
R = P.dual();
assert(R.isEmptySet());
assert(R.Dim==P.Dim);

% the polyhedron must contain the origin in its interior
P = Polyhedron('H', [-1 0 -1;0 -1 -1;1 0 2;0 1 2]);
[~, msg] = run_in_caller('P.dual()');
asserterrmsg(msg, 'The polyhedron must contain the origin in its interior.');
P = Polyhedron([2 1;1 1;1 2;2 2]);
[~, msg] = run_in_caller('P.dual()');
asserterrmsg(msg, 'The polyhedron must contain the origin in its interior.');

% element-wise operation for arrays
P = [Polyhedron.emptySet(2), Polyhedron.fullSpace(3)];
R = P.dual();
assert(numel(R)==2);
assert(R(1).isFullSpace());
assert(R(1).Dim==2);
assert(R(2).isEmptySet());
assert(R(2).Dim==3);

end
