function test_convexset_isempty_06_pass
%
% equality constraint
%

x = sdpvar(2,1);
S = YSet(x, set(x==1), sdpsettings('solver','sedumi','verbose',0));

if S.isEmptySet
    error('The set is not empty.');
end

end