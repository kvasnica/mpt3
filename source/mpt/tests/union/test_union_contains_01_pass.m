function test_union_contains_01_pass
%
% two overlapping Ysets
%

x = sdpvar(5,1);

F1 = set(randn(23,5)*x<=ones(23,1));
F2 = set(randn(23,5)*x<=ones(23,1));

Y(1) = YSet(x,F1).addFunction(AffFunction(randn(1,5),1), 'a');
Y(2) = YSet(x,F2).addFunction(AffFunction(randn(1,5),1), 'a');

U = Union(Y);


v = U.feval(0.1*rand(1,5));

if numel(v)~=2
    error('For the 2 overlapping sets should be two values returned.');
end


end
