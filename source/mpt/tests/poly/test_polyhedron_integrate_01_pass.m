function test_polyhedron_integrate_01_pass
% reject bogus cases

% function must exist
P = Polyhedron('lb', -1, 'ub', 1);
[~, msg] = run_in_caller('P.integrate()');
asserterrmsg(msg, 'The object has no functions.');
P.addFunction(AffFunction(1, 0), 'f');
[~, msg] = run_in_caller('P.integrate(''bogus'')');
asserterrmsg(msg, 'No such function "bogus" in the object.');

% the polyhedron must be bounded
P = Polyhedron('lb', -1);
P.addFunction(AffFunction(1), 'f');
[~, msg] = run_in_caller('P.integrate()');
asserterrmsg(msg, 'The polyhedron must be bounded.');

% function must be affine or quadratic
P = Polyhedron('lb', -1, 'ub', 1);
P.addFunction(@(x) x.^2, 'f');
[~, msg] = run_in_caller('P.integrate()');
asserterrmsg(msg, 'Function "f" must be either affine or quadratic.');

% function must have range 1
P = Polyhedron('lb', -1, 'ub', 1);
P.addFunction(AffFunction([1; 1]), 'f');
[~, msg] = run_in_caller('P.integrate()');
asserterrmsg(msg, 'Range of function "f" must be 1.');

end
