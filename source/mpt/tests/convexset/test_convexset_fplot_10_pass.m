function test_convexset_fplot_10_pass
%
% 2D set no function, return handle
%

x = sdpvar(2,1);
F = [-[1;3]<=x<=[5;4]] + [0.5*x'*x<=0.2];

Y = YSet(x,F,sdpsettings('verbose',0));
Y.addFunction(AffFunction([1,2],-5),'a');
h = Y.fplot;
assert(isscalar(h));

close

end
