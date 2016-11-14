function test_polyhedron_fmin_04_pass
% Polyhedron/fmin() with norm functions

%% 1-norm
P = Polyhedron.unitBox(1);
Q = [1; 2; 3];
P.addFunction(OneNormFunction(Q), 'f');
sol = P.fmin();
xexp = 0; Jexp = norm(Q*xexp, 1);
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

P = Polyhedron('lb', 0.5, 'ub', 2);
Q = [1; 2; 3];
P.addFunction(OneNormFunction(Q), 'f');
sol = P.fmin();
xexp = 0.5; Jexp = norm(Q*xexp, 1);
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

P = Polyhedron('lb', [0.1; 0.5], 'ub', [2; 3]);
Q = [1 2; 3 4; 5 6];
P.addFunction(OneNormFunction(Q), 'f');
sol = P.fmin();
xexp = [0.1; 0.5]; Jexp = norm(Q*xexp, 1);
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

P = Polyhedron('lb', -[0.1; 0.5], 'ub', [2; 3]);
Q = [1 2; 3 4; 5 6];
P.addFunction(OneNormFunction(Q), 'f');
sol = P.fmin();
xexp = [0; 0]; Jexp = norm(Q*xexp, 1);
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

P = Polyhedron.fullSpace(2);
Q = [1 1];
P.addFunction(OneNormFunction(Q), 'f');
sol = P.fmin();
xexp = [0; 0]; Jexp = norm(Q*xexp, 1);
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

%% inf-norm
P = Polyhedron.unitBox(1);
Q = [1; 2; 3];
P.addFunction(InfNormFunction(Q), 'f');
sol = P.fmin();
xexp = 0; Jexp = norm(Q*xexp, Inf);
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

P = Polyhedron('lb', 0.5, 'ub', 2);
Q = [1; 2; 3];
P.addFunction(InfNormFunction(Q), 'f');
sol = P.fmin();
xexp = 0.5; Jexp = norm(Q*xexp, Inf);
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

P = Polyhedron('lb', [0.1; 0.5], 'ub', [2; 3]);
Q = [1 2; 3 4; 5 6];
P.addFunction(InfNormFunction(Q), 'f');
sol = P.fmin();
xexp = [0.1; 0.5]; Jexp = norm(Q*xexp, Inf);
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

P = Polyhedron('lb', -[0.1; 0.5], 'ub', [2; 3]);
Q = [1 2; 3 4; 5 6];
P.addFunction(InfNormFunction(Q), 'f');
sol = P.fmin();
xexp = [0; 0]; Jexp = norm(Q*xexp, Inf);
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

P = Polyhedron.fullSpace(2);
Q = [1 1];
P.addFunction(InfNormFunction(Q), 'f');
sol = P.fmin();
xexp = [0; 0]; Jexp = norm(Q*xexp, Inf);
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);

end
