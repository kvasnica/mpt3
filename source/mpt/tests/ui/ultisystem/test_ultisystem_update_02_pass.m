function test_ultisystem_update_02_pass
% tests ULTISystem/update for systems with parametric uncertainties

%% autonomous system with uncertainty in A
A = {0.8, 1, 1.2}; Am = [A{:}];
sys = ULTISystem('A', A);
x0 = 1;
[xn, y, lambdas, d] = sys.update_equation(x0, []);
assert(numel(lambdas.A)==3);
assert(norm(sum(lambdas.A)-1)<1e-8);
assert(all(lambdas.A>=0));
assert(all(lambdas.A<=1));
At = Am*lambdas.A;
assert(norm(xn-At*x0)<1e-8);
assert(isempty(y));
%
sys.initialize(x0);
[xn, y, lambdas, d] = sys.update();
assert(numel(lambdas.A)==3);
assert(norm(sum(lambdas.A)-1)<1e-8);
At = Am*lambdas.A;
assert(norm(xn-At*x0)<1e-8);
assert(isempty(y));
%
sys.initialize(x0);
[y, lambdas] = sys.output();
assert(isempty(y));
assert(numel(lambdas.A)==3);

%% autonomous system with uncertainty in C
A = 0.8; C = {0.2, 1, 2}; Cm = [C{:}];
sys = ULTISystem('A', A, 'C', C);
x0 = 1;
[xn, y, lambdas, d] = sys.update_equation(x0, []);
assert(lambdas.A==1);
assert(numel(lambdas.C)==3);
assert(norm(sum(lambdas.C)-1)<1e-8);
assert(norm(xn-(A*x0))<1e-8);
Ct = Cm*lambdas.C;
assert(y==Ct*x0);
%
sys.initialize(x0);
[xn, y, lambdas, d] = sys.update();
assert(norm(xn-(A*x0))<1e-8);
Ct = Cm*lambdas.C;
assert(y==Ct*x0);
%
sys.initialize(x0);
[y, lambdas] = sys.output();
Ct = Cm*lambdas.C;
assert(y==Ct*x0);

%% non-autonomous system with uncertainties in B
A = 0.8; B = {1, 2}; Bm = [B{:}];
sys = ULTISystem('A', A, 'B', B);
x0 = 1; u0 = -0.5;
[xn, y, lambdas, d] = sys.update_equation(x0, u0);
Bt = Bm*lambdas.B;
assert(norm(xn-(A*x0+Bt*u0))<1e-8);
assert(isempty(y));
assert(lambdas.A==1);
assert(numel(lambdas.B)==2);
assert(lambdas.C==1);
assert(lambdas.D==1);
assert(d==0);
%
sys.initialize(x0);
[xn, y, lambdas, d] = sys.update(u0);
Bt = Bm*lambdas.B;
assert(norm(xn-(A*x0+Bt*u0))<1e-8);
assert(isempty(y));
assert(lambdas.A==1);
assert(numel(lambdas.B)==2);
assert(lambdas.C==1);
assert(lambdas.D==1);
assert(d==0);
%
sys.initialize(x0);
[y, lambdas] = sys.output();
assert(isempty(y));
assert(lambdas.A==1);
assert(numel(lambdas.B)==2);
assert(lambdas.C==1);
assert(lambdas.D==1);

%% non-autonomous system with uncertainties in A, B
A = {0.8, 1, 1.2}; B = {1, 2}; Bm = [B{:}]; Am = [A{:}];
sys = ULTISystem('A', A, 'B', B);
x0 = 1; u0 = -0.5;
[xn, y, lambdas, d] = sys.update_equation(x0, u0);
At = Am*lambdas.A;
Bt = Bm*lambdas.B;
assert(norm(xn-(At*x0+Bt*u0))<1e-8);
assert(isempty(y));
assert(numel(lambdas.A)==3);
assert(numel(lambdas.B)==2);
assert(lambdas.C==1);
assert(lambdas.D==1);
assert(d==0);
%
sys.initialize(x0);
[xn, y, lambdas, d] = sys.update(u0);
At = Am*lambdas.A;
Bt = Bm*lambdas.B;
assert(norm(xn-(At*x0+Bt*u0))<1e-8);
assert(isempty(y));
assert(numel(lambdas.A)==3);
assert(numel(lambdas.B)==2);
assert(lambdas.C==1);
assert(lambdas.D==1);
assert(d==0);
%
sys.initialize(x0);
[y, lambdas] = sys.output();
assert(isempty(y));
assert(numel(lambdas.A)==3);
assert(numel(lambdas.B)==2);
assert(lambdas.C==1);
assert(lambdas.D==1);

%% non-autonomous system with uncertainties in A, B, C
A = {0.8, 1, 1.2}; B = {1, 2}; C = { 3, 4, 5, 6 };
Bm = [B{:}]; Am = [A{:}]; Cm = [C{:}];
sys = ULTISystem('A', A, 'B', B, 'C', C);
x0 = 1; u0 = -0.5;
[xn, y, lambdas, d] = sys.update_equation(x0, u0);
At = Am*lambdas.A;
Bt = Bm*lambdas.B;
Ct = Cm*lambdas.C;
assert(norm(xn-(At*x0+Bt*u0))<1e-8);
assert(norm(y-(Ct*x0))<1e-8);
assert(numel(lambdas.A)==3);
assert(numel(lambdas.B)==2);
assert(numel(lambdas.C)==4);
assert(lambdas.D==1);
assert(d==0);
%
sys.initialize(x0);
[xn, y, lambdas, d] = sys.update(u0);
At = Am*lambdas.A;
Bt = Bm*lambdas.B;
Ct = Cm*lambdas.C;
assert(norm(xn-(At*x0+Bt*u0))<1e-8);
assert(norm(y-(Ct*x0))<1e-8);
assert(numel(lambdas.A)==3);
assert(numel(lambdas.B)==2);
assert(numel(lambdas.C)==4);
assert(lambdas.D==1);
assert(d==0);
%
sys.initialize(x0);
[y, lambdas] = sys.output();
Ct = Cm*lambdas.C;
assert(norm(y-(Ct*x0))<1e-8);
assert(numel(lambdas.A)==3);
assert(numel(lambdas.B)==2);
assert(numel(lambdas.C)==4);
assert(lambdas.D==1);

end