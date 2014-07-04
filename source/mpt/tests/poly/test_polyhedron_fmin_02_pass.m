function test_polyhedron_fmin_02_pass
% Polyhedron/fmin() with quadratic functions

% % we only allow to minimize convex quadratic functions
% P = Polyhedron.unitBox(1);
% P.addFunction(QuadFunction(-1), 'q');
% [~, msg] = run_in_caller('P.fmin()');
% asserterrmsg(msg, 'The quadratic function to minimize must be convex.');

% minimum in the interior
P = Polyhedron.unitBox(1);
P.addFunction(QuadFunction(1, 1, 2), 'q');
% single function in the object
sol = P.fmin();
xexp = -0.5; Jexp = 1.75;
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

% minimum at the vertex
P = Polyhedron('lb', 0, 'ub', 1);
P.addFunction(QuadFunction(1, 1, 2), 'q');
% single function in the object
sol = P.fmin();
xexp = 0; Jexp = 2;
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

% multiple functions: explicitly specify the function to minimize
P = Polyhedron.unitBox(1);
P.addFunction(QuadFunction(1, 1, 2), 'q');
P.addFunction(AffFunction(-1, 2), 'a');
sol = P.fmin('q');
xexp = -0.5; Jexp = 1.75;
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

% 2D
P = Polyhedron('lb', [-2; -2], 'ub', [-1; -1]);
P.addFunction(QuadFunction(eye(2)), 'q');
sol = P.fmin();
xexp = [-1; -1]; Jexp = 2;
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

% lower-dimensional domain
P = Polyhedron([-1 -1; 1 1]);
P.addFunction(QuadFunction(eye(2), [2 1]), 'q');
sol = P.fmin();
xexp = [-0.75; -0.75]; Jexp = -1.125;
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

% unbounded below (quadratic function with zero quadratic term)
P = Polyhedron.fullSpace(1);
P.addFunction(QuadFunction(0, 1), 'q');
sol = P.fmin();
assert(isnan(sol.xopt));
assert(sol.obj==-Inf);

end
