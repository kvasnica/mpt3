function test_polyhedron_outerApprox_01_pass

% Vrep
d = 3;
V = randn(10, d);
lb = min(V', [], 2);
ub = max(V', [], 2);

% asking for no output
P = Polyhedron(V);
P.outerApprox;
assert(isfield(P.Internal, 'lb'));
assert(isfield(P.Internal, 'ub'));
assert(isequal(P.Internal.lb, lb));
assert(isequal(P.Internal.ub, ub));

% generate the bounding box
P = Polyhedron(V);
B = P.outerApprox;
% internal properties of P should be updated
assert(isfield(P.Internal, 'lb'));
assert(isfield(P.Internal, 'ub'));
assert(isequal(P.Internal.lb, lb));
assert(isequal(P.Internal.ub, ub));
% also the box should contain bounds
assert(isfield(B.Internal, 'lb'));
assert(isfield(B.Internal, 'ub'));
assert(isequal(B.Internal.lb, lb));
assert(isequal(B.Internal.ub, ub));
% the box should be marked as having no redundant constraints
assert(B.irredundantHRep);
% is the box correct?
Bcorrect = Polyhedron('lb', lb, 'ub', ub);
assert(B==Bcorrect);

end
