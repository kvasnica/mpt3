function test_yset_extreme_12_pass
%
% unbounded set
%

x = sdpvar(78,1);
F = (x>=0);

 
S = YSet(x,F);

z = 13.4*rand(78,1);

a = S.extreme(z);

if ~isinf(a.supp)
    error('Here should be unbounded set.');
end

a = S.extreme(-z);

if norm(a.supp)>1e-4
    error('Here should be unbounded set.');
end


end
