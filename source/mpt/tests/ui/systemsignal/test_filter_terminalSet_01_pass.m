function test_filter_terminalSet_01_pass
% tests SystemSignal/filter_terminalSet

x = SystemSignal(3);
x.userData.kind = 'x';

% the filter should not be active by default
assert(~x.hasFilter('terminalSet'));

% add the filter
x.with('terminalSet');

% fully-dimensional set
P = Polyhedron('lb', -ones(x.n, 1), 'ub', ones(x.n, 1));
assert(P.isFullDim());
x.terminalSet = P;

% lower-dimension set
Q = Polyhedron('A', P.A, 'b', P.b, 'Ae', eye(1, x.n), 'be', 0);
assert(~Q.isFullDim());
assert(~Q.isEmptySet());
x.terminalSet = Q;

end
