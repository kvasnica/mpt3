function test_union_05_pass
%
% YSet array
%

x = sdpvar(5,1);
F1 = (x>=0);
F2 = ( norm(x)<=2);
S = [YSet(x,F1), YSet(x,F2)];

U = Union(S);

if U.Num~=2
    error('Must have 2 elements.');
end


end
