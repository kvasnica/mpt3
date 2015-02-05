function test_ultisystem_reachset_02_pass
% ULTISystem/reachableSet with additive disturbances

%% target empty => pre/reach are empty
sys = ULTISystem('A', 1);
X = Polyhedron.emptySet(1);
Z = sys.reachableSet('X', X);
assert(Z.isEmptySet());
Z = sys.reachableSet('X', X, 'direction', 'backward');
assert(Z.isEmptySet());
Z = sys.reachableSet('X', X, 'direction', 'forward');
assert(Z.isEmptySet());

%% no inputs, pre-set (backwards), example 11.8 from MM's book
A = [0.5 0; 1 -0.5];
S = Polyhedron('lb', [-10; -10], 'ub', [10; 10]);
W = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
sys = ULTISystem('A', A);
sys.d.min = [-1; -1];
sys.d.max = [1; 1];
Z = sys.reachableSet('X', S, 'direction', 'backward');
E = Polyhedron([1 0; 1 -0.5; -1 0; -1 0.5], [18; 9; 18; 9]);
assert(Z==E);
% same but with custom D
Z = sys.reachableSet('X', S, 'direction', 'backward', 'D', W);
assert(Z==E);
% same but with only one disturbance
sys = ULTISystem('A', A, 'E', [1; 1]);
sys.d.min = -1;
sys.d.max = 1;
Z = sys.reachableSet('X', S, 'direction', 'backward');
assert(Z==E);
% same but with custom D
W = Polyhedron('lb', -1, 'ub', 1);
Z = sys.reachableSet('X', S, 'direction', 'backward', 'D', W);
assert(Z==E);
% same but with X constructed from bounds
sys.x.min = [-10; -10];
sys.x.max = [10; 10];
Z = sys.reachableSet('direction', 'backward', 'D', W);
assert(Z==E);


%% no inputs, reach-set (forward), example 11.8 from MM's book
A = [0.5 0; 1 -0.5];
S = Polyhedron('lb', [-10; -10], 'ub', [10; 10]);
W = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
sys = ULTISystem('A', A);
sys.d.min = [-1; -1];
sys.d.max = [1; 1];
%
Z = sys.reachableSet('X', S, 'direction', 'forward');
E = Polyhedron([1 -0.5; 0 -1; -1 0; -1 0.5; 0 1; 1 0], [4; 16; 6; 4; 16; 6]);
assert(Z==E);
% direction=forward should be the default
Z = sys.reachableSet('X', S);
assert(Z==E);
% same but with custom D
sys.d.min = [-10; -10];
sys.d.max = [10; 10];
Z = sys.reachableSet('X', S, 'direction', 'forward', 'D', W);
assert(Z==E);
% same but with X constructed from bounds
sys.x.min = [-10; -10];
sys.x.max = [10; 10];
Z = sys.reachableSet('direction', 'forward', 'D', W);
assert(Z==E);

%% inputs, pre-set (backwards), example 11.9 from MM's book
A = [1.5 0; 1 -1.5];
B = [1; 0];
S = Polyhedron('lb', [-10; -10], 'ub', [10; 10]);
W = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
U = Polyhedron('lb', -5, 'ub', 5);
sys = ULTISystem('A', A, 'B', B);
sys.d.min = [-1; -1];
sys.d.max = [1; 1];
% custom D and U
Z = sys.reachableSet('X', S, 'direction', 'backward', 'D', W, 'U', U);
E = Polyhedron('H', [1.5 0 14;-1.5 0 14;1 -1.5 9;-1 1.5 9]);
assert(Z==E);
% custom U
sys.u.min = -10;
sys.u.max = 10;
Z = sys.reachableSet('X', S, 'direction', 'backward', 'U', U);
assert(Z==E);
% custom D
sys.u.min = -5;
sys.u.max = 5;
Z = sys.reachableSet('X', S, 'direction', 'backward', 'D', W);
assert(Z==E);
% custom D
sys.d.min = [-100; -100];
sys.d.max = [100; 100];
Z = sys.reachableSet('X', S, 'direction', 'backward', 'D', W);
assert(Z==E);
% X constructed from bounds
sys.x.min = [-10; -10];
sys.x.max = [10; 10];
Z = sys.reachableSet('direction', 'backward', 'D', W);
assert(Z==E);

%% inputs, reach-set (forward), example 11.9 from MM's book
A = [1.5 0; 1 -1.5];
B = [1; 0];
S = Polyhedron('lb', [-10; -10], 'ub', [10; 10]);
W = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
U = Polyhedron('lb', -5, 'ub', 5);
sys = ULTISystem('A', A, 'B', B);
sys.d.min = [-1; -1];
sys.d.max = [1; 1];
sys.u.min = -5;
sys.u.max = 5;
%
Z = sys.reachableSet('X', S, 'direction', 'forward');
E = Polyhedron('H', [0.554700196225229 -0.832050294337844 16.6410058867569;1 0 21;-0.554700196225229 0.832050294337844 16.6410058867569;-1 0 21;0 1 26;0 -1 26]);
assert(Z==E);
% direction=forward should be the default
Z = sys.reachableSet('X', S);
assert(Z==E);
% same but with custom D
sys.d.min = [-10; -10];
sys.d.max = [10; 10];
Z = sys.reachableSet('X', S, 'direction', 'forward', 'D', W);
assert(Z==E);
% same but with custom U and D
sys.u.min = -10;
sys.u.max = 10;
Z = sys.reachableSet('X', S, 'direction', 'forward', 'D', W, 'U', U);
assert(Z==E);
% same but with X constructed from bounds
sys.x.min = [-10; -10];
sys.x.max = [10; 10];
Z = sys.reachableSet('direction', 'forward', 'D', W, 'U', U);
assert(Z==E);

end
