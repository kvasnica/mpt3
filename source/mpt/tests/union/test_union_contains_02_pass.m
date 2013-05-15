function test_union_contains_02_pass
%
% two Ysets
%

x = sdpvar(2,1);

A = randn(3,2);
F = set(A*x<=ones(3,1));
F = F+set(norm(randn(3,2)*x-randn(3,1))<= ones(3,1));

Fn = set(A*x>=ones(3,1)) + set(randn(4,2)*x<=2*ones(4,1));

Y(1) = YSet(x,F);
Y(2) = YSet(x,Fn);

U = Union(Y);

[isin,inwhich,closest] = U.contains( 0.01*rand(2,1));

if ~isin && isempty(closest)
    error('The closest regions should be found always when the point is not contained anywhere.');
end


end
