function test_polyhedron_outerApprox_02_pass

% Hrep
d = 3;
V = randn(10, d);
lb = min(V', [], 2);
ub = max(V', [], 2);
Q = Polyhedron(V);
Q.minHRep();
H = Q.H;

% asking for no output
P = Polyhedron('H', H);
P.outerApprox;
assert(isfield(P.Internal, 'lb'));
assert(isfield(P.Internal, 'ub'));
assert(norm(P.Internal.lb-lb, 1)<1e-8);
assert(norm(P.Internal.ub-ub, 1)<1e-8);

% generate the bounding box
P = Polyhedron('H', H);
B = P.outerApprox;
% internal properties of P should be updated
assert(isfield(P.Internal, 'lb'));
assert(isfield(P.Internal, 'ub'));
assert(norm(P.Internal.lb-lb, 1)<1e-8);
assert(norm(P.Internal.ub-ub, 1)<1e-8);
% also the box should contain bounds
assert(isfield(B.Internal, 'lb'));
assert(isfield(B.Internal, 'ub'));
assert(norm(B.Internal.lb-lb, 1)<1e-8);
assert(norm(B.Internal.ub-ub, 1)<1e-8);
% the box should be marked as having no redundant constraints
assert(B.irredundantHRep);
% is the box correct?
Bcorrect = Polyhedron('lb', lb, 'ub', ub);
assert(B==Bcorrect);

end
