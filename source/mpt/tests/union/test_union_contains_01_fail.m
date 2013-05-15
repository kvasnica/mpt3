function test_union_contains_01_fail
%
% wrong dim
%

x = sdpvar(2,1);

F = set(norm(randn(8,2)*x-randn(8,1))< ones(8,1));

Y(1) = YSet(x,F);
Y(2) = YSet(x,set(-5<x<5));

U = Union(Y);

[isin,inwhich,closest] = U.contains( [1,2,3]);

end
