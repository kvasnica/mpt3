function test_convexset_isbounded_04_pass
%
% trivially bounded array
% 
 x = sdpvar(2,1);
 F1 = ( x'*x <= 5);
 F2 = (randn(11,2)*x<=ones(11,1)); 
 Y1 = YSet(x,F1);
 Y2 = YSet(x,F2);
 
 Y = [Y1;Y2];
 
 ts = Y.isBounded;
 
 if any(~ts)
     error('These sets are bounded.');
 end
 
end
