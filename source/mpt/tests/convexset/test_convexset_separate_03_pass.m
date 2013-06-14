function test_convexset_separate_03_pass
%
% simple 2D set and a point outside the set
%

x = sdpvar(2,1);
F = [x'*x <= 1; ( 2*x(1)-0.5*x(2)<=0.5)];
Y = YSet(x,F);

v = [-2,0];

s = Y.separate(v);


if norm(s(3)+1.5,Inf)>1e-4
    error('The separating hyperplane must pass the poin [-1.5, 0].');
end

end
