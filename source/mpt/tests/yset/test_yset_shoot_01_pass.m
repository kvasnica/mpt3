function test_yset_shoot_01_pass
%
% simple 1D test shooting
%


x = sdpvar(1);

F = ( norm(x) <= 1);

S = YSet(x,F);

z = 5*randn(1);

s = S.shoot(z);

if ~S.contains(s*z)
    error('The point must be inside of the set.');
end


end
