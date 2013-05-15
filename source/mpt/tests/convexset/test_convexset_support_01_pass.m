function test_convexset_support_01_pass
%
% 1D set and the point outside of the set
%

x = sdpvar(1);
F = set(x^2 <  1) + set( x<0.5);
Y = YSet(x,F);

v = 10;

s = Y.support(v);

if norm(5-s)>1e-4
    error('Wrong support in positive direction.')
end

end