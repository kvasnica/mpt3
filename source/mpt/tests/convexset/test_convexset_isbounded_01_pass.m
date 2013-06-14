function test_convexset_isbounded_01_pass
%
% trivially bounded
% 
 x = sdpvar(1);
 F = ( -1 <= x <= 1);
 Y = YSet(x,F);
 
 if ~Y.isBounded
     error('This is set is bounded.');
 end
 
end
