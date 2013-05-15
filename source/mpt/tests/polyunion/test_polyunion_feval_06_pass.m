function test_polyunion_feval_06_pass
%
% evaluation based on two indices/two strings
%

P = ExamplePoly.randVrep('d',4);
T = P.triangulate;

T.addFunction(AffFunction(randn(4)),'a');
T.addFunction(AffFunction(randn(4)),'b');
T.addFunction(AffFunction(randn(4)),'c');

U = PolyUnion('Set',T,'Overlaps',false,'Convex',true,'FullDim',true,'Bounded',true);

x = P.interiorPoint.x;

y1=U.feval(x,{'a','c'});

if ~iscell(y1)
    error('The result must be cell because we evaluate 3 functions and arrays of polyunions.')
end

end
