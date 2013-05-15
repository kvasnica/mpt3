function test_polyunion_feval_03_pass
%
% PWA, polycomplex
%

P = ExamplePoly.randVrep('d',4);
T = P.triangulate;

T.addFunction(AffFunction(rand(1,4)),'a');
T.addFunction(AffFunction(rand(1,4)),'b');


U = PolyUnion(T);

x = P(1).interiorPoint.x;

y1=U.feval(x,'b');

if iscell(y1)
    error('The result must be double because we evaluate only 1 function.')
end

Un = U.getFunction('a');

y2 = Un.feval(x);

if iscell(y2)
    error('Only double here.');
end

y3 = U.feval(x);
if ~iscell(y3)
    error('Cell must be here because we have 2 functions.');
end

end