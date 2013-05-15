function test_yset_extreme_05_pass
%
% the point lies inside the set
%

x = sdpvar(3,1);

A = [-1.4276      -0.5365      -1.1811
     -0.33983      -1.2165      0.14164
       0.5406        1.304     -0.63833
     -0.54233      -1.7214        2.439
      -0.9743    -0.033898     -0.36792
     -0.14877      0.51118     -0.33665
      -0.6341     -0.96274      0.17304];
b = [ 2.05  1.437  0.92541  0.43479  1.6457  0.24903  1.6099];
F = set(x'*x <= 1) + set( A*x<=b' );

S = YSet(x,F);

% z is inside the set
z = [0.3; 0.1; -0.2];
if ~S.contains(z)
    error('This point must lie inside S, otherwise the test is not valid.');
end

s = S.extreme(z);

v = [ 0.84724; 0.10336; -0.52105];

if norm(v-s.x,Inf)>1e-3
    error('Wrong extreme point.');
end

% the computed point must lie on the boundary of the set
if ~S.contains(s.x)
    error('This point lies on the boundary of this set.');
end
w = v;
% move the point outside of the set a tolerance bit
w(1) = v(1)*1.001;  
if S.contains(w)
    error('This point must be outside of the set.');
end


end
