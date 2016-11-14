function test_yset_shoot_03_pass
%
% 3D test
%

x1 = sdpvar(1,1);x2 = sdpvar(1,1);x3 = sdpvar(1,1);
F = [4*x1-4*x2+4*x3-20+2*x2-2*x3+9+2*x3-13+24>=0,
     4-(x1+x2+x3)>=0,
     6-(3*x2+x3)>=0,
     2-x1>=0,
     3-x3>=0,
     x1>=0,
     x2>=0,
     x3>=0];
 
S = YSet([x1;x2;x3],F)  ;

z = 10*randn(3,1);

a = S.shoot(z);

if ~S.contains(a*z)
    error('The point must be inside of the set.');
end


end
