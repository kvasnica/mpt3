function test_convexset_plot_13_pass
%
% wrong color identifyier
%

x = sdpvar(2,1);
F1 = set( -1<= x <= 2)  + set( rand(1,2)*x<=3 );

Y1 = YSet(x,F1,sdpsettings('verbose',0));

[worked, msg] = run_in_caller('h = Y1.plot(''wire'',true,''Marker'',''s'',''MarkerSize'',5,''color'',''wrong color''); ');
assert(~worked);
asserterrmsg(msg,'Given color name is not in the list of supported colors.');

end