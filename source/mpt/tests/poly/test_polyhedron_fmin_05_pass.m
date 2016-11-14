function test_polyhedron_fmin_05_pass
% Polyhedron/fmin() with general functions

% trivially infeasible
P = Polyhedron.emptySet(3);
f = @(x) sum(x);
P.addFunction(f, 'f');
sol = P.fmin();
assert(sol.obj==Inf);
assert(all(isnan(sol.xopt)));
assert(numel(sol.xopt)==3);

% the function to minimize must be scalar
P = Polyhedron.unitBox(2)*2*pi;
f = @(x) sin(x);
P.addFunction(f, 'f');
[~, msg] = run_in_caller('P.fmin()');
asserterrmsg(msg, 'The function to minimize must be scalar.');

% non-convex quadratic function
P = Polyhedron.unitBox(1);
P.addFunction(QuadFunction(-1), 'q');
sol = P.fmin();
Jexp = -1;
assert(norm(sol.obj-Jexp, Inf)<1e-5);
assert(isfield(sol, 'info')); % indicates yalmip was used
assert(isequal(sol.how, 'ok'));

% -cos(x+1)+2 on -1<=x<=1 has minimum at x=-1 with J=1
P = Polyhedron.unitBox(1)*2;
f = @(x) -cos(x+1)+2;
P.addFunction(f, 'f');
sol = P.fmin();
xexp = -1; Jexp = f(xexp);
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);
assert(isfield(sol, 'info'));
assert(isequal(sol.how, 'ok'));

% |x-0.5| has minimum at 0.5
P = Polyhedron.unitBox(1)*2;
f = @(x) abs(x-0.5);
P.addFunction(f, 'f');
sol = P.fmin();
xexp = 0.5; Jexp = f(xexp);
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);
assert(isfield(sol, 'info'));
assert(isequal(sol.how, 'ok'));

% ||x-[0.4; -2]||_Inf-sum(x) has minimum at [-0.6; -3]
P = Polyhedron.unitBox(2)*3;
f = @(x) norm(x-[0.4; -2], Inf)-0.1*sum(x);
P.addFunction(f, 'f');
sol = P.fmin();
xexp = [0.4; -2]; Jexp = f(xexp);
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);
assert(isfield(sol, 'info'));
assert(isequal(sol.how, 'ok'));

% fancy nonlinear function
P = Polyhedron.unitBox(2)*2*pi;
f = @(x) sin(x)'*abs(x);
P.addFunction(f, 'f');
sol = P.fmin();
xexp = [4.91317987629674;4.91317987612124]; Jexp = f(xexp);
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);
assert(isfield(sol, 'info'));
assert(isequal(sol.how, 'ok'));

% unbounded
P = Polyhedron('ub', 2);
f = @(x) x;
P.addFunction(f, 'f');
sol = P.fmin();
assert(isnan(sol.xopt));
assert(sol.obj==-Inf);
assert(isequal(sol.how, 'unbounded'));
assert(isfield(sol, 'info'));


end
