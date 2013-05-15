function test_union_contains_02_fail
%
% union in different dimension
%

x = sdpvar(2,1);

F = set(norm(randn(8,2)*x-randn(8,1))< ones(8,1));

y = sdpvar(3,1);
G = set(randn(9,3)*y<ones(9,1));

Y(1) = YSet(x,F);
Y(2) = YSet(x,set(-5<x<5));
Y(3) = YSet(y,G);

U = Union(Y);

[isin,inwhich,closest] = U.contains( [1,2,3]);

end
