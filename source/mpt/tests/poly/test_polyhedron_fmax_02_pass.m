function test_polyhedron_fmax_02_pass
% Polyhedron/fmax() with concave quadratic functions

% maximum in the interior
P = Polyhedron.unitBox(1);
P.addFunction(QuadFunction(-1, 1, 2), 'q');
% single function in the object
sol = P.fmax();
xexp = 0.5; Jexp = -xexp^2 + xexp + 2;
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

% maximum at the vertex
P = Polyhedron('lb', 0.5, 'ub', 1);
P.addFunction(QuadFunction(-1, 1, 2), 'q');
% single function in the object
sol = P.fmax();
xexp = 0.5; Jexp = -xexp^2 + xexp + 2;
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

% multiple functions: explicitly specify the function to minimize
P = Polyhedron.unitBox(1);
P.addFunction(QuadFunction(-1, 1, 2), 'q');
P.addFunction(AffFunction(-1, 2), 'a');
sol = P.fmax('q');
xexp = 0.5; Jexp = -xexp^2 + xexp + 2;
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

% 2D
P = Polyhedron('lb', [-2; -2], 'ub', [-1; -1]);
P.addFunction(QuadFunction(-eye(2)), 'q');
sol = P.fmax();
xexp = [-1; -1]; Jexp = -xexp'*xexp;
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

% lower-dimensional domain
P = Polyhedron([-1 -1; 1 1]);
P.addFunction(QuadFunction(-eye(2), [2 1]), 'q');
sol = P.fmax();
xexp = [0.75; 0.75]; Jexp = -xexp'*xexp+[2 1]*xexp;
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

% unbounded above (quadratic function with zero quadratic term)
P = Polyhedron.fullSpace(1);
P.addFunction(QuadFunction(0, 1), 'q');
sol = P.fmax();
assert(isnan(sol.xopt));
assert(sol.obj==Inf);

end
