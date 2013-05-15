function test_convexset_fplot_08_pass
%
% two 1D sets, two vector functions with names, plot based on the name and
% index, use colors, and markings
%

x = sdpvar(1);
F1 = set(-1<=x<=5) + set(0.5*x^2<=0.2);
Y1 = YSet(x,F1,sdpsettings('verbose',0));
F2 = set(x<=0.3) + set(-x^2>=-.4);
Y2 = YSet(x,F2,sdpsettings('verbose',0));

Y = [Y1,Y2];

A1 = AffFunction(rand(3,1),rand(3,1));
A2 = AffFunction(rand(4,1),rand(4,1));
Q = QuadFunction(rand(1,1,2),rand(2,1),rand(2,1));

Y.addFunction(A1,'A1');
Y.addFunction(A2,'A2');
Y.addFunction(Q,'Q');

% plot second value from the vectorized function
h1 = Y.fplot({'A2','Q'},2,'Color','g','LineWidth',4,'LineStyle','-.');
assert(length(h1)==4);
h2 = Y.fplot({'A1','A2'},3,'LineWidth',3,'FaceColor','c');
assert(length(h2)==4);

close all


end
