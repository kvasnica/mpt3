function test_convexset_fplot_02_pass
%
% 1D set one function
%

x = sdpvar(1);
F = [-1<=x<=5] + [0.5*x^2<=0.2];
Y = YSet(x,F,sdpsettings('verbose',0));
A = AffFunction(5.6,-1);
Y.addFunction(A, 'f');

h1 = Y.fplot;
assert(isscalar(h1));

h2 = Y.fplot('f');
assert(isscalar(h2));

close all;

end
