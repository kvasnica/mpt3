function test_yset_shoot_05_pass
%
% empty set, infeasible
%

x = sdpvar(15,1);
F = set(randn(142,15)*x<=10*randn(142,1)) + set(randn(18,15)*x==randn(18,1));

 
S = YSet(x,F);

z = 13.4*rand(15,1);

a = S.shoot(z);

if ~isnan(a)
    error('Here should be empty set.');
end


end
