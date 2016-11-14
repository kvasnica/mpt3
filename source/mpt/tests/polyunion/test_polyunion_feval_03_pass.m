function test_polyunion_feval_03_pass
%
% PWA, polycomplex
%

P = ExamplePoly.randVrep('d',4);
T = P.triangulate;
fa = rand(1, 4);
fb = rand(1, 4);
T.addFunction(AffFunction(fa),'a');
T.addFunction(AffFunction(fb),'b');
U = PolyUnion(T);
x = P(1).interiorPoint.x;
y = U.feval(x,'b');
assert(y==fb*x);

Un = U.getFunction('a');
y = Un.feval(x);
assert(y==fa*x);

% evaluation of multiple functions must fail
[worked, msg] = run_in_caller('y = U.feval(x);');
assert(~worked);
asserterrmsg(msg, 'The object has multiple functions, specify the one to evaluate.');

end
