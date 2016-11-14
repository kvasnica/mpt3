function test_polyhedron_fmin_03_pass
% Polyhedron/fmin() with affine functions

% trivially infeasible
P = Polyhedron.emptySet(1);
P.addFunction(AffFunction(1), 'f');
sol = P.fmin();
assert(sol.obj==Inf);

P = Polyhedron.unitBox(1);
P.addFunction(AffFunction(1, -3), 'f');
sol = P.fmin();
xexp = -1; Jexp = -4;
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

% 2D
P = Polyhedron('lb', [-2; -2], 'ub', [-1; -1]);
P.addFunction(AffFunction([1 1], 3), 'f');
sol = P.fmin();
xexp = [-2; -2]; Jexp = -1;
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

% constant function
P = Polyhedron.unitBox(1);
P.addFunction(AffFunction(0, 0.5), 'f');
sol = P.fmin();
Jexp = 0.5;
assert(norm(sol.obj-Jexp, Inf)<1e-5);

% unbounded
P = Polyhedron.fullSpace(1);
P.addFunction(AffFunction(1, 0), 'f');
sol = P.fmin();
assert(isnan(sol.xopt));
assert(sol.obj==-Inf);

% unbounded
P = Polyhedron.fullSpace(1);
P.addFunction(AffFunction(-1, 0), 'f');
sol = P.fmin();
assert(isnan(sol.xopt));
assert(sol.obj==-Inf);

% unbounded below
P = Polyhedron('ub', 2);
P.addFunction(AffFunction(1, 0), 'f');
sol = P.fmin();
assert(isnan(sol.xopt));
assert(sol.obj==-Inf);

end
