function test_yset_extreme_04_pass
%
% matrix variable
%

P = sdpvar(2);
A =  [-0.98698      -1.5855
       1.7663      0.80514];

F = [P>=0, A'*P + P*A <= -diag([0.1,0.2])];

S = YSet(P(:),F);

V = [ -1.1453
      0.55238
      0.55238
      -2.7078];
s = S.extreme(V);

if norm(s.x-[  1.2192; 0.65296; 0.65296; 1.1617])>1e-4
    error('Wrong exreme point.');
end

end
