function test_convexset_support_02_pass
%
% 1D set and the point inside of the set
%

x = sdpvar(1);
F = [x^2 <= 1] + [ x<=0.5 ];
Y = YSet(x,F);

v = -0.5;

s = Y.support(v);

if norm(0.5-s)>1e-4
    error('Wrong support in positive direction.')
end

end
