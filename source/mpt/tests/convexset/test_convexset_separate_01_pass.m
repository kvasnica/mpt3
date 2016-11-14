function test_convexset_separate_01_pass
%
% simple 1D set and a point
%

x = sdpvar(1);
F = [x^2 <=  1;  x<=0.5];
Y = YSet(x,F);

v = [-3];

s = Y.separate(v);

if norm(s(2)/s(1)+2,Inf)>1e-4
    error('The separating must be -2.');
end

end
