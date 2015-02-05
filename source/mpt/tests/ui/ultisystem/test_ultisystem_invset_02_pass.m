function test_ultisystem_invset_02_pass
% ULTISystem/invariantSet() with valid inputs

%% autonomous system with additive disturbance, example 11.12 from MM's book
A = [0.5 0; 1 -0.5];
sys = ULTISystem('A', A);
sys.x.min = [-10; -10];
sys.x.max = [10; 10];
sys.d.min = [-1; -1];
sys.d.max = [1; 1];
Z = sys.invariantSet();
E = Polyhedron('H', [1 -0.5 9;-1 0.5 9;1 0 10;0 1 10;-1 0 10;0 -1 10]);
assert(Z==E);
% custom D
sys.d.min = [-10; -10];
sys.d.max = [10; 10];
D = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
Z = sys.invariantSet('D', D);
assert(Z==E);
% custom D and X
sys.x.min = [1; 1];
sys.x.max = [2; 2];
X = Polyhedron('lb', [-10; -10], 'ub', [10; 10]);
Z = sys.invariantSet('D', D, 'X', X);
assert(Z==E);

%% system with inputs and additive disturbances, example 11.13
A = [1.5 0; 1 -1.5];
B = [1; 0];
sys = ULTISystem('A', A, 'B', B);
sys.x.min = [-10; -10];
sys.x.max = [10; 10];
sys.d.min = 0.1*[-1; -1];
sys.d.max = 0.1*[1; 1];
sys.u.min = -5;
sys.u.max = 5;
[Z, conv, iters] = sys.invariantSet();
assert(conv);
assert(iters==36);
E = Polyhedron('H', [0 1.24807544150677 4.64284423092339;0 -1.24807544150677 4.64284423092339;1 -1.5 3.62000646929322;-1 1.5 3.62000646929322]);
assert(Z==E);
% custom D
sys.d.min = [-10; -10];
sys.d.max = [10; 10];
D = Polyhedron('lb', 0.1*[-1; -1], 'ub', 0.1*[1; 1]);
[Z, conv, iters] = sys.invariantSet('D', D);
assert(conv);
assert(iters==36);
assert(Z==E);
% custom D and X
sys.x.min = [1; 1];
sys.x.max = [2; 2];
X = Polyhedron('lb', [-10; -10], 'ub', [10; 10]);
[Z, conv, iters] = sys.invariantSet('D', D, 'X', X);
assert(conv);
assert(iters==36);
assert(Z==E);
% custom D, X and U
sys.u.min = 1;
sys.u.max = 2;
U = Polyhedron('lb', -5, 'ub', 5);
[Z, conv, iters] = sys.invariantSet('D', D, 'X', X, 'U', U);
assert(conv);
assert(iters==36);
assert(Z==E);
% custom number of iterations
[Z, converged, iters] = sys.invariantSet('D', D, 'X', X, 'U', U, 'maxIterations', 5);
assert(Z~=E);
assert(iters==5);
assert(~converged);


end