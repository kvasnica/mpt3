function test_union_removeAllFunctions_03_pass
%
% arrays of unions
%

x = sdpvar(3,1);
F1=set(randn(12,3)*x<=ones(12,1));
F2=set(randn(12,3)*x<=ones(12,1));
F3=set(randn(12,3)*x<=ones(12,1));

Y(1) = YSet(x,F1);
Y(2) = YSet(x,F2);
Y(3) = YSet(x,F3);

for i=1:3,
    Y(i).addFunction(AffFunction(randn(1,3)),'a');
    Y(i).addFunction(AffFunction(randn(1,3)),'b');
end

U(1) = Union(Y);
U(2) = Union(Y(3));

U.removeAllFunctions;

for i=1:2
    s = U(i).listFunctions;
    assert(isempty(s));
end

end
