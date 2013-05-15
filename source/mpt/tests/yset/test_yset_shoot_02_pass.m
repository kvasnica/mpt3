function test_yset_shoot_02_pass
%
% 2D test shooting, no lifting variables
%


x = sdpvar(2,1);

F = set( -2*x(2) <= x(1)) + set( -1<= x <= 1);

% if we leave default solver it throws an unknown error
%S = YSet(x,F,sdpsettings('solver','sedumi','verbose',0));
S = YSet(x,F);

z = randn(1,2);

a = S.shoot(z);

if ~S.contains(a*z)
    error('The point must be inside of the set.');
end


end
