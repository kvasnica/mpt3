function test_convexset_fplot_05_pass
%
% 1D set, three functions with names, plot based on the name 
%

x = sdpvar(1);
F = set(-1<=x<=5) + set(0.5*x^2<=0.2);

Y = YSet(x,F,sdpsettings('verbose',0));
A1 = AffFunction(5.6,-1);
A2 = AffFunction(5,2);
Q = QuadFunction(2,-1);

Y.addFunction(A1,'A1');
Y.addFunction(A2,'A2');
Y.addFunction(Q, 'q');

h1 = Y.fplot('A2');
assert(length(h1)==1);
h2 = Y.fplot({'A1','A2'});
assert(length(h2)==2);

close all


end
