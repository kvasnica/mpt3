function test_convexset_isbounded_02_pass
%
% trivially unbounded
% 
 x = sdpvar(1);
 F = [ x <= 1];
 Y = YSet(x,F);
 
 if Y.isBounded
     error('This is set is unbounded.');
 end
 
end
