function test_convexset_isempty_03_pass
%
% empty set, but with many variables
%

x = sdpvar(150,1);
F = set(randn(1745,150)*x<=ones(1745,1)) + set(x>=0) + set(x<=-1);
Y = YSet(x,F);

if ~Y.isEmptySet
    error('This set is empty.');
end

end
