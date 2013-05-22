function test_polyunion_feval_01_pass
%
% two functions, no names
%

P = ExamplePoly.randVrep('d',4);

A = rand(1, 4);
B = rand(1, 4);
P.addFunction(AffFunction(A), 'a');
P.addFunction(AffFunction(B), 'b');
U = PolyUnion(P);
x = P(1).interiorPoint.x;

% cannot evaluate multiple functions
[~, msg] = run_in_caller('y1=U.feval(x)');
asserterrmsg(msg, 'The object has multiple functions, specify the one to evaluate.');

% single function evaluation should work
f = U.feval(x, 'a');
assert(f==A*x);
f = U.feval(x, 'b');
assert(f==B*x);

end
