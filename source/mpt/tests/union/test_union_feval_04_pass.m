function test_union_feval_04_pass
%
% nooverlaps, polycomplex
%

P = ExamplePoly.randVrep('d',4);
T= P.triangulate;

T.addFunction(Function(@(x) 1./(1+x.^2)),'h');
T.addFunction(Function(@(x) sin(x)./(1+cos(x).^2)),'k');
T.addFunction(Function(@(x) x.*sin(x)./(1+cos(x).^2)),'l');

U = Union(T);

x = P.interiorPoint.x;

y1=U.feval(x,'k');
y2 = U.feval(x,{'h', 'k'});

if norm(y1-y2{2})>1e-4
    error('The result must be the same.');
end


end
