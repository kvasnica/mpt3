function test_polyhedron_fmax_03_pass
% Polyhedron/fmax() with affine functions

% trivially infeasible
P = Polyhedron.emptySet(1);
P.addFunction(AffFunction(1), 'f');
sol = P.fmax();
assert(sol.obj==-Inf);

P = Polyhedron.unitBox(1);
P.addFunction(AffFunction(1, -3), 'f');
sol = P.fmax();
xexp = 1; Jexp = xexp-3;
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

% 2D
P = Polyhedron('lb', [-2; -2], 'ub', [-1; -1]);
P.addFunction(AffFunction([1 1], 3), 'f');
sol = P.fmax();
xexp = [-1; -1]; Jexp = [1 1]*xexp+3;
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

% constant function
P = Polyhedron.unitBox(1);
P.addFunction(AffFunction(0, 0.5), 'f');
sol = P.fmax();
Jexp = 0.5;
assert(norm(sol.obj-Jexp, Inf)<1e-5);

% unbounded above
P = Polyhedron.fullSpace(1);
P.addFunction(AffFunction(1, 0), 'f');
sol = P.fmax();
assert(isnan(sol.xopt));
assert(sol.obj==Inf);

% unbounded above
P = Polyhedron.fullSpace(1);
P.addFunction(AffFunction(-1, 0), 'f');
sol = P.fmax();
assert(isnan(sol.xopt));
assert(sol.obj==Inf);

% unbounded above
P = Polyhedron('ub', 2);
P.addFunction(AffFunction(-1, 0), 'f');
sol = P.fmax();
assert(isnan(sol.xopt));
assert(sol.obj==Inf);

end
