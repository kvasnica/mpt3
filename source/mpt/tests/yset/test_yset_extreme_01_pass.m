function test_yset_extreme_01_pass
%
% 1D set, compute lower/upper bounds
%

x = sdpvar(1);

F = ( 5*x <= 1 );

S = YSet(x,F);

s1 = S.extreme(1);
if norm(0.2-s1.x)>1e-4
    error('Wrong exreme point.');
end
s2 = S.extreme(-1);
if ~isinf(s2.supp)
    error('This is unbounded set.');
end

end