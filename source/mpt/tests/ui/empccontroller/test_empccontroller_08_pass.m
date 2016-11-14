function test_empccontroller_08_pass
% tests EMINController(PolyUnion) syntax


% the optimizer must not be an empty polyunion
U = PolyUnion;
[worked, msg] = run_in_caller('EMPCController(U);');
assert(~worked);
assert(~isempty(findstr(msg, 'Optimizer 1 must contain at least one region.')));

% the optimizer must contain the 'primal' function
U = PolyUnion('Set', Polyhedron('lb', -1, 'ub', 1));
[worked, msg] = run_in_caller('EMPCController(U);');
assert(~worked);
assert(~isempty(findstr(msg, 'Optimizer 1 must contain the "primal" function.')));

% the optimizer must contain the 'primal' function
P = Polyhedron('lb', -1, 'ub', 1);
P.addFunction(AffFunction(1, 0), 'primal');
U = PolyUnion('Set', P);
[worked, msg] = run_in_caller('EMPCController(U);');
assert(~worked);
assert(~isempty(findstr(msg, 'Optimizer 1 must contain the "obj" function.')));

% all polyunions mustn't be empty
P = Polyhedron('lb', -1, 'ub', 1);
P.addFunction(AffFunction(1, 0), 'primal');
P.addFunction(AffFunction(1, 0), 'obj');
U = PolyUnion('Set', P);
U2 = PolyUnion;
[worked, msg] = run_in_caller('EMPCController([U U2]);');
assert(~worked);
assert(~isempty(findstr(msg, 'Optimizer 2 must contain at least one region.')));

% all polyunions must be in same dimension
P1 = Polyhedron('lb', -1, 'ub', 1);
P1.addFunction(AffFunction(1, 0), 'primal');
P1.addFunction(AffFunction(1, 0), 'obj');
U1 = PolyUnion(P1);

P2 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
P2.addFunction(AffFunction([0 0], 0), 'primal');
P2.addFunction(AffFunction([0 0], 0), 'obj');
U2 = PolyUnion(P2);

U = [U1 U2];
[worked, msg] = run_in_caller('EMPCController(U);');
assert(~worked);
assert(~isempty(findstr(msg, 'All optimizers must have equal dimensions.')));


% all polyunions must have same length of the primal optimizer
P1 = Polyhedron('lb', -1, 'ub', 1);
P1.addFunction(AffFunction(1, 0), 'primal');
P1.addFunction(AffFunction(1, 0), 'obj');
U1 = PolyUnion(P1);

P2 = Polyhedron('lb', -1, 'ub', 1);
P2.addFunction(AffFunction([0;0], [1;1]), 'primal');
P2.addFunction(AffFunction(0, 0), 'obj');
U2 = PolyUnion(P2);

U = [U1 U2];
[worked, msg] = run_in_caller('EMPCController(U);');
assert(~worked);
assert(~isempty(findstr(msg, 'All optimizers must have the same number of optimization variables.')));

% import from a single polyunion
P1 = Polyhedron('lb', -1, 'ub', 1);
P1.addFunction(AffFunction(1, 0), 'primal');
P1.addFunction(AffFunction(1, 0), 'obj');
U1 = PolyUnion(P1);
E = EMPCController(U1);
assert(E.optimizer.Set(1)==P1);

% and import from multiple polyunions
P1 = Polyhedron('lb', -1, 'ub', 1);
P1.addFunction(AffFunction([0;0], [1;1]), 'primal');
P1.addFunction(AffFunction(0, 0), 'obj');
P2 = Polyhedron('lb', -2, 'ub', 2);
P2.addFunction(AffFunction([0;0], [1;1]), 'primal');
P2.addFunction(AffFunction(0, 0), 'obj');
U1 = PolyUnion(P1); U2 = PolyUnion(P2);
E = EMPCController([U2 U1]);
assert(numel(E.optimizer)==2);
assert(E.optimizer(1).Set(1)==P2);
assert(E.optimizer(2).Set(1)==P1);

end
