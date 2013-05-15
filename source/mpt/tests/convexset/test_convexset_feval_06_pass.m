function test_convexset_feval_06_pass
%
% one set, general function
%

P = Polyhedron('A',randn(17,5),'b',3*ones(17,1));

P.addFunction(Function(@(x)x.^2),'square');

xc = P.chebyCenter;

y = P.feval(xc.x);



end