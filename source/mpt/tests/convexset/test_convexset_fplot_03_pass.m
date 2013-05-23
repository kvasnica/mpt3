function test_convexset_fplot_03_pass
%
% 1D set two functions
%

x = sdpvar(1);
F = [-1<=x<=5] + [0.5*x^2<=0.2];
Y = YSet(x,F,sdpsettings('verbose',0));
A = AffFunction(5.6,-1);
Q = QuadFunction(2,-3,0.5);
Y.addFunction(A, 'aff');
Y.addFunction(Q, 'quad');

h = Y.fplot('aff');
assert(isscalar(h));

h = Y.fplot('quad');
assert(isscalar(h));

close all;

end
