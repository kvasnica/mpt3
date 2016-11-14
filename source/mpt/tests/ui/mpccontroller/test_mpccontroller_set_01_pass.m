function test_mpccontroller_set_01_pass
% tests setter method for the 'optimizer' property

E = MPCController;

% cannot set optimizer to double
[worked, msg] = run_in_caller('E.optimizer = 1;');
assert(~worked);
assert(~isempty(findstr(msg, 'The optimizer must be an instance of the @optimizer class.')));

% cannot set optimizer to a polyhedron
[worked, msg] = run_in_caller('E.optimizer = Polyhedron;');
assert(~worked);
assert(~isempty(findstr(msg, 'The optimizer must be an instance of the @optimizer class.')));

% cannot set optimizer to an empty polyunion
[worked, msg] = run_in_caller('E.optimizer = PolyUnion;');
assert(~worked);
assert(~isempty(findstr(msg, 'The optimizer must be an instance of the @optimizer class.')));

% setting optimizer to [] should work
E.optimizer = [];

% setting to an optimizer object should work
x = sdpvar(1);
u = sdpvar(1);
opt = optimizer([-1<=x+u<=1], x'*x, [], x, u);
E.optimizer = opt;

end
