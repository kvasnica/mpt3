function test_polyunion_feval_04_pass
%
% general function, polycomplex
%

P = ExamplePoly.randVrep('d',4);
T = P.triangulate;

T.addFunction(AffFunction(rand(1,4)),'a');
T.addFunction(Function(@(x)norm(x)), 'b');
T.addFunction(Function(@(x)x.^2-0.1*x),'anonymous');


U = PolyUnion('Set',T,'Overlaps',false,'Convex',true,'FullDim',true,'Bounded',true);

x = P.interiorPoint.x;

y1=U.feval(x);

if ~iscell(y1)
    error('The result must be cell because we evaluate 3 functions.')
end

Un = U.getFunction('b');

y2 = Un.feval(x);

if iscell(y2)
    error('Only double here.');
end

y3 = U.feval(x,'anonymous');
if iscell(y3)
    error('Double must be here because we have 1 function.');
end

end
