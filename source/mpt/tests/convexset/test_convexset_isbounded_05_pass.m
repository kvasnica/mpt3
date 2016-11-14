function test_convexset_isbounded_05_pass
%
% bounded:  1 0 0 array
% 
 x = sdpvar(15,1);
 F1 = ( -5<= x <= 5);
 F2 = (randn(8,15)*x<=ones(8,1)); 
 F3 = (randn(3,15)*x<=ones(3,1)); 
 
 Y1 = YSet(x,F1);
 Y2 = YSet(x,F2);
 Y3 = YSet(x,F3);
 
 Y = [Y1;Y2,Y3];
 
 ts = Y.isBounded;
 
 if any(ts~=[1 0 0]')
     error('These sets are bounded 1 0 0.');
 end
 
end
