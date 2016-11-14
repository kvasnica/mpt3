function test_convexset_feval_07_pass
%
% arrays with different functions must be rejected

f1 = @(x) x;
f2 = @(x) x^2;
f3 = @(x) x^3;
P1 = Polyhedron('lb', -1, 'ub', 1);
P2 = Polyhedron('lb', 0, 'ub', 2);
P3 = Polyhedron('lb', 0.5, 'ub', 3);
P4 = Polyhedron('lb', 0, 'ub', 4);
P1.addFunction(f1, 'f');
P2.addFunction(f2, 'f2');
P3.addFunction(f3, 'f');
P4.addFunction(f1, 'f2');
Q = [P1 P2 P3 P4];
x = 0.1;

% function name provided, not all sets have the function defined
[~, msg] = run_in_caller('Q.feval(x, ''f'');');
asserterrmsg(msg, 'No such function "f" in the object.');

% no function name, not all sets have the function defined
[~, msg] = run_in_caller('Q.feval(x);');
asserterrmsg(msg, 'No such function "f" in set 2.');

% no function name, multiple functions
P1.addFunction(f1, 'another');
[~, msg] = run_in_caller('Q.feval(x);');
asserterrmsg(msg, 'The object has multiple functions, specify the one to evaluate.');
