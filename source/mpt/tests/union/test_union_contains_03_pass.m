function test_union_contains_03_pass
%
% two Ysets, two polyhedra
%

x = sdpvar(2,1);

A = randn(3,2);
F = set(A*x<=ones(3,1));
F = F+set(norm(randn(3,2)*x-randn(3,1)) <= ones(3,1));

Fn = set(A*x>=ones(3,1)) + set(randn(4,2)*x<=2*ones(4,1));

Y(1) = YSet(x,F);
Y(2) = YSet(x,Fn);

U = Union(Y);
U.add(ExamplePoly.randHrep);
U.add(ExamplePoly.randVrep);

[isin,inwhich,closest] = U.contains( 0.01*rand(2,1),true);

if ~isin && isempty(closest)
    error('The closest regions should be found always when the point is not contained anywhere.');
end
if numel(inwhich)~=1
    error('The length of inwhich must be 1 for fastbreak option.');
end


end
