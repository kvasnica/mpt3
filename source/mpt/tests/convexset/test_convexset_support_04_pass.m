function test_convexset_support_04_pass
%
% simple 2D set and a point lies at the edge of the set
%

x = sdpvar(2,1);
F = set(x'*x <  1) + set( 2*x(1)-0.5*x(2)<0.5);
Y = YSet(x,F);

v = [1;-2];

s = Y.support(v);

x = [0;-1];

if norm(x'*v-s)>1e-4
    error('The separating hyperplane must be zero, because the point lies inside the set.');
end

end