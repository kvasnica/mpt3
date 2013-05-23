function test_convexset_fplot_06_pass
%
% 1D set, three functions with names, plot based on the name and index
%

x = sdpvar(1);
F = [-1<=x<=5] + [0.5*x^2<=0.2];

Y = YSet(x,F,sdpsettings('verbose',0));
A1 = AffFunction(rand(3,1),rand(3,1));
A2 = AffFunction(rand(4,1),rand(4,1));
Q = QuadFunction(rand(1,1,2),rand(2,1),rand(2,1));

Y.addFunction(A1,'A1');
Y.addFunction(A2,'A2');
Y.addFunction(Q,'Q');

% plot second value from the vectorized function
figure; Y.fplot('A2', 'position', 2);
figure; Y.fplot('Q', 'position', 2);
figure; Y.fplot('A1', 'position', 3);
figure; Y.fplot('A2', 'position', 3, 'show_set', true);

close all


end
