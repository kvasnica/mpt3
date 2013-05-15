function test_yset_shoot_06_pass
%
% unbounded set
%

x = sdpvar(78,1);
F = set(x>=0);

 
S = YSet(x,F);

z = 13.4*rand(78,1);

a = S.shoot(z);

if ~isinf(a)
    error('Here should be unbounded set.');
end

a = S.shoot(-z);

if norm(a)>1e-4
    error('Here should be unbounded set.');
end


end
