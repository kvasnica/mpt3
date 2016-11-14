function test_union_removeAllFunctions_02_pass
%
% example from the documentation
%

x = sdpvar(3,1);
F1=(randn(12,3)*x<=ones(12,1));
F2=(randn(12,3)*x<=ones(12,1));


Y(1) = YSet(x,F1);
Y(2) = YSet(x,F2);

for i=1:2,
    Y(i).addFunction(AffFunction(randn(1,3)),'a');
    Y(i).addFunction(AffFunction(randn(1,3)),'b');
end

U = Union(Y);

U.removeAllFunctions;

s = U.listFunctions;

if numel(s)~=0
    error('No functions here.');
end

end
