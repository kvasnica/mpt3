function test_empccontroller_set_01_pass
% tests setter method for the 'optimizer' property

E = EMPCController;

% cannot set optimizer to double
[worked, msg] = run_in_caller('E.optimizer = 1;');
assert(~worked);
assert(~isempty(findstr(msg, 'Optimizer must be an instance of the @PolyUnion class.')));

% cannot set optimizer to a polyhedron
[worked, msg] = run_in_caller('E.optimizer = Polyhedron;');
assert(~worked);
assert(~isempty(findstr(msg, 'Optimizer must be an instance of the @PolyUnion class.')));

% cannot set optimizer to an empty polyunion
[worked, msg] = run_in_caller('E.optimizer = PolyUnion;');
assert(~worked);
assert(~isempty(findstr(msg, 'Optimizer 1 must contain at least one region.')));

% setting optimizer to [] should work
E.optimizer = [];

% setting to non-empty polyunion should work
P = Polyhedron('lb', -1, 'ub', 1);
P.addFunction(AffFunction(1, 0), 'primal');
P.addFunction(AffFunction(1, 0), 'obj');
U = PolyUnion(P);
E.optimizer = U;
assert(E.optimizer.Set == P);

end
