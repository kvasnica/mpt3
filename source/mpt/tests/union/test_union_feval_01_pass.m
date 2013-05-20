function test_union_feval_01_pass
%
% tests validation of inputs

% union with a single function
P = Polyhedron('lb', -1, 'ub', 1);
P.addFunction(@(x) x, 'fun1');
Us = Union;
Us.add(P);
x = 0.1;

% union with multiple functions
Q = Polyhedron('lb', -1, 'ub', 1);
Q.addFunction(@(x) x, 'fun1');
Q.addFunction(@(x) x, 'fun2');
Um = Union;
Um.add(Q);

% no inputs
[~, msg] = run_in_caller('Us.feval()');
asserterrmsg(msg, 'Not enough input arguments.');
[~, msg] = run_in_caller('Um.feval()');
asserterrmsg(msg, 'Not enough input arguments.');

% point must be a vector
[~, msg] = run_in_caller('Us.feval(''abc'')');
asserterrmsg(msg, 'Input argument must be a real vector.');
[~, msg] = run_in_caller('Um.feval(''abc'')');
asserterrmsg(msg, 'Input argument must be a real vector.');

% cannot evaluate multiple functions
[~, msg] = run_in_caller('Um.feval(x)');
asserterrmsg(msg, 'The object has multiple functions, specify the one to evaluate.');

% function name must be a string
[~, msg] = run_in_caller('Us.feval(x, 1)');
asserterrmsg(msg, 'The function name must be a string.');
[~, msg] = run_in_caller('Um.feval(x, 1)');
asserterrmsg(msg, 'The function name must be a string.');

% % unrecognized option
% [~, msg] = run_in_caller('Us.feval(x, ''option'', ''value'')');
% asserterrmsg(msg, 'Unrecognized option "option".');
% [~, msg] = run_in_caller('Um.feval(x, ''option'', ''value'')');
% asserterrmsg(msg, 'Unrecognized option "option".');

% function must exist
[~, msg] = run_in_caller('Us.feval(x, ''unknown'')');
asserterrmsg(msg, 'No such function "unknown" in the object.');
[~, msg] = run_in_caller('Um.feval(x, ''unknown'')');
asserterrmsg(msg, 'No such function "unknown" in the object.');

% tiebreak must be either a function or a function handle
[~, msg] = run_in_caller('Us.feval(x, ''tiebreak'', 1)');
asserterrmsg(msg, 'The tiebreak option must be a string or a function handle.');
[~, msg] = run_in_caller('Um.feval(x, ''fun1'', ''tiebreak'', 1)');
asserterrmsg(msg, 'The tiebreak option must be a string or a function handle.');

% tiebreak function must be present in the union
[~, msg] = run_in_caller('Us.feval(x, ''tiebreak'', ''sin'')');
asserterrmsg(msg, 'No such function "sin" in the object.');

% regions must be a vector
[~, msg] = run_in_caller('Us.feval(x, ''regions'', ''1'')');
asserterrmsg(msg, 'The regions option must be a vector of integers.');
[~, msg] = run_in_caller('Um.feval(x, ''fun2'', ''regions'', ''1'')');
asserterrmsg(msg, 'The regions option must be a vector of integers.');

% arrays of unions must be rejected
UU = [Us Us];
[~, msg] = run_in_caller('UU.feval(x)');
asserterrmsg(msg, 'This method does not support arrays. Use the forEach() method.');

end
