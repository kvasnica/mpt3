function test_polyhedron_fmax_01_pass
% tests error checks in Polyhedron/fmax

P = Polyhedron.unitBox(1);

[~, msg] = run_in_caller('P.fmax()');
asserterrmsg(msg, 'The object has no functions.');

P = Polyhedron.unitBox(1);
P.addFunction(AffFunction([1; 1]), 'f1');
P.addFunction(QuadFunction(-1), 'f2');
[~, msg] = run_in_caller('P.fmax()');
asserterrmsg(msg, 'The object has multiple functions, specify the one to optimize.');

[~, msg] = run_in_caller('P.fmax(1)');
asserterrmsg(msg, 'The function name must be a string.');

[~, msg] = run_in_caller('P.fmax(''bogus'')');
asserterrmsg(msg, 'No such function "bogus" in the object.');

[~, msg] = run_in_caller('P.fmax(''f1'')');
asserterrmsg(msg, 'The function to minimize must be scalar.');

% trivially infeasible
P = Polyhedron.emptySet(1);
P.addFunction(QuadFunction(1), 'q');
P.addFunction(AffFunction(1), 'a');
s = P.fmax('q');
assert(isnan(s.xopt));
assert(s.obj==-Inf);
s = P.fmax('a');
assert(isnan(s.xopt));
assert(s.obj==-Inf);

% no arrays please
Q = Polyhedron.unitBox(2);
[~, msg] = run_in_caller('fmax([P Q]);');
asserterrmsg(msg, 'This method does not support arrays. Use the forEach() method.');

end
