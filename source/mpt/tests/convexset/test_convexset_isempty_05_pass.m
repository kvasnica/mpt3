function test_convexset_isempty_05_pass
%
% array of unbounded sets
%

x = sdpvar(3,1);
F1 = set( randn(2,3)*x<=ones(2,1));
F2 = set( randn(2,3)*x<=ones(2,1));
Y1 = YSet(x,F1);
Y2 = YSet(x,F2);


Y = [Y1; Y2];

if any(Y.isEmptySet)
    error('This set is unbounded, not empty.');
end

end
