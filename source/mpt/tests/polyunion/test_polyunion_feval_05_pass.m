function test_polyunion_feval_05_pass
%
% array of polyunion
%

P = ExamplePoly.randVrep('d',4);
P.addFunction(QuadFunction(randn(4)), 'q');
T = P.triangulate;

T.addFunction(AffFunction(rand(1,4)),'q');
T.addFunction(Function(@(x)norm(x)), 'b');
T.addFunction(Function(@(x)x.^2-0.1*x),'anonymous');
U(1) = PolyUnion('Set',T,'Overlaps',false,'Convex',true,'FullDim',true,'Bounded',true);
U(2) = PolyUnion('Set',P,'Overlaps',false,'Convex',true,'FullDim',true,'Bounded',true);

x = P.interiorPoint.x;

% reject arrays
[worked, msg] = run_in_caller('U.feval(x);');
asserterrmsg(msg, 'This method does not support arrays. Use the forEach() method.');

end
