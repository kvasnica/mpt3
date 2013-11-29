function test_bintreeunion_tomatlab_01_pass

c = onCleanup(@() delete('pu_export.m'));

P = BinTreePolyUnion;
fname = 'pu_export';
fun = 'bogus';
tiebreak = 'another';

[~, msg] = run_in_caller('P.toMatlab();');
asserterrmsg(msg, 'Not enough input arguments.');

[~, msg] = run_in_caller('P.toMatlab(fname);');
asserterrmsg(msg, 'Not enough input arguments.');

[~, msg] = run_in_caller('P.toMatlab(fname, fun);');
asserterrmsg(msg, 'The object has no regions.');

[~, msg] = run_in_caller('P.toMatlab(fname, fun, tiebreak);');
asserterrmsg(msg, 'The object has no regions.');

P = PolyUnion(Polyhedron.unitBox(1));
P.addFunction(@(x) x, 'handle');
P.addFunction(AffFunction(1), 'affine');
P.addFunction(QuadFunction(1), 'quadratic');
P.addFunction(AffFunction([1;1]), 'affine2');

[~, msg] = run_in_caller('P.toMatlab(fname, fun, tiebreak);');
asserterrmsg(msg, 'No such function "bogus" in the object.');

[~, msg] = run_in_caller('P.toMatlab(fname, ''affine'', ''tiebreak'');');
asserterrmsg(msg, 'No such function "tiebreak" in the object.');

[~, msg] = run_in_caller('P.toMatlab(fname, ''handle'', ''quadratic'');');
asserterrmsg(msg, 'Only affine and quadratic functions can be exported.');

[~, msg] = run_in_caller('P.toMatlab(fname, ''affine'', ''handle'');');
asserterrmsg(msg, 'Only affine and quadratic functions can be exported.');

[~, msg] = run_in_caller('P.toMatlab(fname, ''affine'', ''affine2'');');
asserterrmsg(msg, 'The tie breaker must be a scalar-valued function.');

end
