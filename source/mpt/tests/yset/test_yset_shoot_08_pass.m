function test_yset_shoot_08_pass
%
% lifting
%

x = sdpvar(2,1);
F = [-5 <= x(1) <= 5,x(2) == -(x(1)-2).^2];

Y = YSet(x,F);

% infeasible point
z = [2;1];
a = Y.shoot(z);

if ~isnan(a)
    error('This given point is not feasible.');
end


end