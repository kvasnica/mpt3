function test_polyhedron_outerApprox_04_pass
% outerApprox for unbounded polyhedra

% Vrep
P = ExamplePoly.randVrep('d',5,'nr',3);
assert(~P.isBounded);
B = P.outerApprox;
assert(~B.isBounded);
assert(isfield(P.Internal, 'lb'));
assert(isfield(P.Internal, 'ub'));
assert(isfield(B.Internal, 'lb'));
assert(isfield(B.Internal, 'ub'));

% Vrep
lb = [-Inf; -Inf]; ub = [0; 0];
P = Polyhedron('V', [0 0], 'R', [-1 0; 0 -1]);
assert(~P.isBounded);
B = P.outerApprox;
assert(~B.isBounded);
assert(isfield(P.Internal, 'lb'));
assert(isfield(P.Internal, 'ub'));
assert(isfield(B.Internal, 'lb'));
assert(isfield(B.Internal, 'ub'));
assert(isequal(P.Internal.lb, lb));
assert(isequal(P.Internal.ub, ub));
assert(isequal(B.Internal.lb, lb));
assert(isequal(B.Internal.ub, ub));

% Hrep
lb = [-1; -Inf]; ub = [0; 0];
P = Polyhedron([1 0; 0 1; -1 0], [0; 0; 1]);
assert(~P.isBounded);
B = P.outerApprox;
assert(~B.isBounded);
assert(isfield(P.Internal, 'lb'));
assert(isfield(P.Internal, 'ub'));
assert(isfield(B.Internal, 'lb'));
assert(isfield(B.Internal, 'ub'));
assert(isequal(P.Internal.lb, lb));
assert(isequal(P.Internal.ub, ub));
assert(isequal(B.Internal.lb, lb));
assert(isequal(B.Internal.ub, ub));

end
