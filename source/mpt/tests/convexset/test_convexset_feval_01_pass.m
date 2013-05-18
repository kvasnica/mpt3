function test_convexset_feval_01_pass
%
% x in 1D
%

Ps = Polyhedron('lb', -1, 'ub', 1);
a = 1;
b = 1;
Ps.addFunction(AffFunction(a,b), 'f');
Pm = Polyhedron('lb', -1, 'ub', 1);
Pm.addFunction(@(x) x, 'f1');
Pm.addFunction(@(x) x, 'f2');
x = 0.1;

% no inputs
[~, msg] = run_in_caller('Ps.feval()');
asserterrmsg(msg, 'Not enough input arguments.');
[~, msg] = run_in_caller('Pm.feval()');
asserterrmsg(msg, 'Not enough input arguments.');

% point must be a vector
[~, msg] = run_in_caller('Ps.feval(''abc'')');
asserterrmsg(msg, 'Input argument must be a real');
[~, msg] = run_in_caller('Pm.feval(''abc'', ''f1'')');
asserterrmsg(msg, 'Input argument must be a real');

% cannot evaluate multiple functions
[~, msg] = run_in_caller('Pm.feval(x)');
asserterrmsg(msg, 'The object has multiple functions, specify the one to evaluate.');

% function name must be a string
[~, msg] = run_in_caller('Ps.feval(x, 1)');
asserterrmsg(msg, 'The function name must be a string.');
[~, msg] = run_in_caller('Pm.feval(x, 1)');
asserterrmsg(msg, 'The function name must be a string.');

% function must exist
[~, msg] = run_in_caller('Ps.feval(x, ''unknown'')');
asserterrmsg(msg, 'No such function "unknown" in the object.');
[~, msg] = run_in_caller('Pm.feval(x, ''unknown'')');
asserterrmsg(msg, 'No such function "unknown" in the object.');

% must work on empty sets
QQ = Ps([]);
[fval, feasible] = QQ.feval(x);
assert(isempty(fval));
assert(~feasible);
QQ = Pm([]);
[fval, feasible] = QQ.feval(x);
assert(isempty(fval));
assert(~feasible);

end
