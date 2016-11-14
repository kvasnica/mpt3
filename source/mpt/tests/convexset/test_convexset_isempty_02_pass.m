function test_convexset_isempty_02_pass
%
% empty set
%

x = sdpvar(1);
F = [x<=0; x>=1];
Y = YSet(x,F);

if ~Y.isEmptySet
    error('This set is empty.');
end

end
