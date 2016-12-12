function test_polyhedron_fmax_04_pass
% Polyhedron/fmax() with general functions

% trivially infeasible
P = Polyhedron.emptySet(3);
f = @(x) sum(x);
P.addFunction(f, 'f');
sol = P.fmax();
assert(sol.obj==-Inf);
assert(all(isnan(sol.xopt)));
assert(numel(sol.xopt)==3);

% the function to maximize must be scalar
P = Polyhedron.unitBox(2)*2*pi;
f = @(x) sin(x);
P.addFunction(f, 'f');
[~, msg] = run_in_caller('P.fmax()');
asserterrmsg(msg, 'The function to minimize must be scalar.');

% % maximizing convex quadratic function is not a convex problem
% P = Polyhedron.unitBox(1);
% P.addFunction(QuadFunction(1), 'q');
% sol = P.fmax();
% Jexp = 1;
% assert(norm(sol.obj-Jexp, Inf)<1e-5);
% assert(isfield(sol, 'info')); % indicates yalmip was used
% assert(isequal(sol.how, 'ok'));

% -cos(x+1)+2
P = Polyhedron.unitBox(1)*3;
f = @(x) -cos(x+1)+2;
P.addFunction(f, 'f');
sol = P.fmax();
xexp = 2.14159261474821; Jexp = f(xexp);
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);
assert(isfield(sol, 'info'));
assert(isequal(sol.how, 'ok'));

% -|x-0.5| has minimum at 0.5
P = Polyhedron.unitBox(1)*2;
f = @(x) -abs(x-0.5);
P.addFunction(f, 'f');
sol = P.fmax();
xexp = 0.5; Jexp = f(xexp);
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);
assert(isfield(sol, 'info'));
assert(isequal(sol.how, 'ok'));

% -||x-[0.4; -2]||_Inf-sum(x)
P = Polyhedron.unitBox(2)*3;
f = @(x) -norm(x-[0.4; -2], Inf)-0.1*sum(x);
P.addFunction(f, 'f');
sol = P.fmax();
xexp = [0.4; -2]; Jexp = f(xexp);
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);
assert(isfield(sol, 'info'));
assert(isequal(sol.how, 'ok'));

% fancy nonlinear function
P = Polyhedron.unitBox(2)*2*pi;
f = @(x) sin(x)'*abs(x);
P.addFunction(f, 'f');
sol = P.fmax();
xexp = -[4.91317987629674;4.91317987612124]; Jexp = f(xexp);
assert(norm(sol.xopt-xexp, Inf)<1e-5);
assert(norm(sol.obj-Jexp, Inf)<1e-5);
assert(isfield(sol, 'info'));
assert(isequal(sol.how, 'ok'));

% unbounded
P = Polyhedron('lb', 2);
f = @(x) x;
P.addFunction(f, 'f');
sol = P.fmax();
assert(isnan(sol.xopt));
assert(sol.obj==Inf);
assert(isequal(sol.how, 'unbounded'));
assert(isfield(sol, 'info'));


end
