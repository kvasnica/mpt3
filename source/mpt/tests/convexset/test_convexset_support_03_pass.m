function test_convexset_support_03_pass
%
% simple 2D set and a point outside the set
%

x = sdpvar(2,1);
F = set(x'*x <  1) + set( 2*x(1)-0.5*x(2)<0.5);
Y = YSet(x,F);

v = [1;0];

s = Y.support(v);

x = [0.47059,0.88235];

if norm(x*v-s)>1e-4
    error('The separating hyperplane must pass the poin [-1.5, 0].');
end

end