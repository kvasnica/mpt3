function test_union_06_pass
%
% YSet array, union Array
%

x = sdpvar(5,1);
F1 = set(x>=0);
F2 = set( norm(x)<=2);
S = [YSet(x,F1), YSet(x,F2)];

U(1) = Union(S);
F3 = set( x<=1);
U(2) = Union(YSet(x,F3));

if U(1).Num~=2
    error('Must have 2 elements.');
end

if U(2).Num~=1
    error('Must have 1 element.');
end


end
