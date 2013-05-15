function test_yset_project_10_pass
%
% unbounded set
%

x = sdpvar(78,1);
F = set(x>=0);

 
S = YSet(x,F);

z = 13.4*rand(78,1);

s = S.project(z);

if s.dist>1e-4
    error('Here should be unbounded set.');
end


end
