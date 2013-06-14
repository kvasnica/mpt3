function test_convexset_isempty_01_pass
%
% not empty set
%

x = sdpvar(1);
F = (x<=0);
Y = YSet(x,F);

if Y.isEmptySet
    error('This set is not empty.');
end

end
