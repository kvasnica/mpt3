function test_yset_extreme_10_pass
%
% lifting
%

x = sdpvar(2,1);
F = [-5 <= x(1) <= 5,x(2) == -(x(1)-2).^2];

Y = YSet(x,F);

s = Y.extreme([0;5]);
if norm(s.x-[2;0],Inf)>1e-4
    error('Wrong point.');
end



end