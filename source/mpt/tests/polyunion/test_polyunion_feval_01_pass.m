function test_polyunion_feval_01_pass
%
% two functions, no names
%

P = ExamplePoly.randVrep('d',4);

P.addFunction(AffFunction(rand(1,4)), 'a');
P.addFunction(AffFunction(rand(1,4)), 'b');


U = PolyUnion(P);

x = P(1).interiorPoint.x;

y1=U.feval(x);

if ~iscell(y1)
    error('The result must be a cell because we evaluate 2 functions.')
end


end
