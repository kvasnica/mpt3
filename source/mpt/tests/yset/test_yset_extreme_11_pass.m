function test_yset_extreme_11_pass
%
% empty set, infeasible
%

x = sdpvar(15,1);
F = set(randn(142,15)*x<=10*randn(142,1)) + set(randn(18,15)*x==randn(18,1));

 
S = YSet(x,F);

z = 13.4*rand(15,1);

a = S.extreme(z);

if ~isnan(a.supp)
    error('Here should be empty set.');
end


end
