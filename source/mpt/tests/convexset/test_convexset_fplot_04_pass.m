function test_convexset_fplot_04_pass
%
% 1D set two functions, plot the second one only
%

x = sdpvar(1);
F = set(-1<=x<=5) + set(0.5*x^2<=0.2);

Y = YSet(x,F,sdpsettings('verbose',0));
A = AffFunction(5.6,-1);
Q = QuadFunction(2,-3,0.5);

Y.addFunction(A, 'a');
Y.addFunction(Q, 'q');

h1 = Y.fplot('q');
assert(length(h1)==1);

close all;

end
