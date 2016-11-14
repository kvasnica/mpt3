function test_ultisystem_update_01_pass
% tests ULTISystem/update for systems with additive disturbances

%% autonomous system with additive disturbance
A = 0.8; E = 1;
sys = ULTISystem('A', A, 'E', E);
sys.d.min = -1;
sys.d.max = 1;
x0 = 1;
[xn, y, lambdas, d] = sys.update_equation(x0, []);
assert(norm(xn-(A*x0+E*d))<1e-8);
assert(isempty(y));
assert(lambdas.A==1);
assert(lambdas.B==1);
assert(lambdas.C==1);
assert(lambdas.D==1);
assert(~isempty(d));
assert(sys.d.min<=d);
assert(sys.d.max>=d);
%
sys.initialize(x0);
[xn, y, lambdas, d] = sys.update();
assert(norm(xn-(A*x0+E*d))<1e-8);
assert(isempty(y));
assert(lambdas.A==1);
assert(lambdas.B==1);
assert(lambdas.C==1);
assert(lambdas.D==1);
assert(~isempty(d));
%
sys.initialize(x0);
[y, lambdas] = sys.output();
assert(isempty(y));
assert(lambdas.A==1);
assert(lambdas.B==1);
assert(lambdas.C==1);
assert(lambdas.D==1);

%% autonomous system with additive disturbance
A = 0.8; E = 1.2; C = 0.2;
sys = ULTISystem('A', A, 'E', E, 'C', C);
sys.d.min = -1;
sys.d.max = 1;
x0 = 1;
[xn, y, lambdas, d] = sys.update_equation(x0, []);
assert(norm(xn-(A*x0+E*d))<1e-8);
assert(y==C*x0);
assert(lambdas.A==1);
assert(lambdas.B==1);
assert(lambdas.C==1);
assert(lambdas.D==1);
assert(~isempty(d));
assert(sys.d.min<=d);
assert(sys.d.max>=d);
%
sys.initialize(x0);
[xn, y, lambdas, d] = sys.update();
assert(norm(xn-(A*x0+E*d))<1e-8);
assert(y==C*x0);
assert(lambdas.A==1);
assert(lambdas.B==1);
assert(lambdas.C==1);
assert(lambdas.D==1);
assert(~isempty(d));
%
sys.initialize(x0);
[y, lambdas] = sys.output();
assert(y==C*x0);
assert(lambdas.A==1);
assert(lambdas.B==1);
assert(lambdas.C==1);
assert(lambdas.D==1);

%% autonomous system with additive disturbance (polytopic bounds)
A = 0.8; E = 1.2; C = 0.2;
sys = ULTISystem('A', A, 'E', E, 'C', C);
sys.d.min = -1e4+1;
sys.d.max = 1e4-1;
sys.d.with('setConstraint');
sys.d.setConstraint = Polyhedron('lb', -0.1, 'ub', 0.1);
x0 = 1;
[xn, y, lambdas, d] = sys.update_equation(x0, []);
assert((d<=0.1) && (d>=-0.1)); % setConstraints overides d.min/d.max
assert(norm(xn-(A*x0+E*d))<1e-8);
assert(y==C*x0);
assert(lambdas.A==1);
assert(lambdas.B==1);
assert(lambdas.C==1);
assert(lambdas.D==1);
assert(~isempty(d));
assert(sys.d.min<=d);
assert(sys.d.max>=d);
%
sys.initialize(x0);
[xn, y, lambdas, d] = sys.update();
assert((d<=0.1) && (d>=-0.1)); % setConstraints overides d.min/d.max
assert(norm(xn-(A*x0+E*d))<1e-8);
assert(y==C*x0);
assert(lambdas.A==1);
assert(lambdas.B==1);
assert(lambdas.C==1);
assert(lambdas.D==1);
assert(~isempty(d));

%% non-autonomous system with additive disturbance
A = 0.8; E = -1; B = 1;
sys = ULTISystem('A', A, 'E', E, 'B', B);
sys.d.min = -1;
sys.d.max = 1;
x0 = 1; u0 = -0.5;
[xn, y, lambdas, d] = sys.update_equation(x0, u0);
assert(norm(xn-(A*x0+E*d+B*u0))<1e-8);
assert(isempty(y));
assert(lambdas.A==1);
assert(lambdas.B==1);
assert(lambdas.C==1);
assert(lambdas.D==1);
assert(~isempty(d));
assert(sys.d.min<=d);
assert(sys.d.max>=d);
%
sys.initialize(x0);
[xn, y, lambdas, d] = sys.update(u0);
assert(norm(xn-(A*x0+E*d+B*u0))<1e-8);
assert(isempty(y));
assert(lambdas.A==1);
assert(lambdas.B==1);
assert(lambdas.C==1);
assert(lambdas.D==1);
assert(~isempty(d));
%
sys.initialize(x0);
[y, lambdas] = sys.output();
assert(isempty(y));
assert(lambdas.A==1);
assert(lambdas.B==1);
assert(lambdas.C==1);
assert(lambdas.D==1);

%% non-autonomous system with additive disturbance
A = 0.8; E = 0.5; B = 1; C = 0.2; D = 0.4;
sys = ULTISystem('A', A, 'E', E, 'B', B, 'C', C, 'D', D);
sys.d.min = -1;
sys.d.max = 1;
x0 = 1; u0 = -0.5;
[xn, y, lambdas, d] = sys.update_equation(x0, u0);
assert(norm(xn-(A*x0+E*d+B*u0))<1e-8);
assert(y==C*x0+D*u0);
assert(lambdas.A==1);
assert(lambdas.B==1);
assert(lambdas.C==1);
assert(lambdas.D==1);
assert(~isempty(d));
assert(sys.d.min<=d);
assert(sys.d.max>=d);
%
sys.initialize(x0);
[xn, y, lambdas, d] = sys.update(u0);
assert(norm(xn-(A*x0+E*d+B*u0))<1e-8);
assert(y==C*x0+D*u0);
assert(lambdas.A==1);
assert(lambdas.B==1);
assert(lambdas.C==1);
assert(lambdas.D==1);
assert(~isempty(d));
%
sys.initialize(x0);
[y, lambdas] = sys.output(u0);
assert(y==C*x0+D*u0);
assert(lambdas.A==1);
assert(lambdas.B==1);
assert(lambdas.C==1);
assert(lambdas.D==1);

end