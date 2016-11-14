function test_convexset_separate_04_pass
%
% simple 2D set and a point lies at the edge of the set
%

x = sdpvar(2,1);
F = [(x'*x <=  1); ( 2*x(1)-0.5*x(2)<=0.5)];
Y = YSet(x,F);

v = [0,1];

s = Y.separate(v);

if ~isempty(s)
    if norm(s(3),Inf)>1e-3
        error('The separating hyperplane must be zero, because the point lies inside the set.');
    end
end

end
