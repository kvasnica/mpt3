function test_union_07_pass
%
% empty  YSet
%

x = sdpvar(5,1);
F = set( -1<=x<=-2);
U = Union(YSet(x,F));

if U.Num~=0
    error('Must be empty because YSet is empty');
end

end
