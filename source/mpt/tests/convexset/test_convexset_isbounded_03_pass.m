function test_convexset_isbounded_03_pass
%
% trivially unbounded
% 
 x = sdpvar(2,1);
 F = [ x(1)+x(2) >= 1; x(1)>=0 ];
 Y = YSet(x,F);
 
 if Y.isBounded
     error('This is set is unbounded.');
 end
 
end
