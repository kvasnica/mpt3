function test_convexset_separate_02_pass
%
% simple 1D set and a point inside the set
%

x = sdpvar(1);
F = set(x^2 <=  1) + set( x<=0.5);
Y = YSet(x,F);

v = 0;

s = Y.separate(v);

if norm(s,1)>1e-4
    error('The separating must be 0 (the point is inside the set).');
end

end
