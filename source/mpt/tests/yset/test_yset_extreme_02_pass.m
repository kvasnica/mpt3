function test_yset_extreme_02_pass
%
% 2D set, circle
%

x = sdpvar(1,2);

F = ( x*x' <= 1 );

S = YSet(x,F);

s1 = S.extreme([1,1]);
x1 = [cos(pi/4); sin(pi/4)];

s2 = S.extreme([1,-1]);
x2 = [cos(-pi/4); sin(-pi/4)];

if norm(x1-s1.x)>1e-4
    error('Wrong exreme point.');
end
if norm(x2-s2.x)>1e-4
    error('Wrong exreme point.');
end

end
