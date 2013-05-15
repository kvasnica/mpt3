function test_convexset_fplot_13_pass
%
% 2D set, two functions, plot based on a string
%

x = sdpvar(2,1);
F = set(-[1;3]<=x<=[5;4]) + set(0.5*x'*x<=0.2) + set(randn(1,2)*x<=0.5);

Y = YSet(x,F,sdpsettings('verbose',0));

A = AffFunction(randn(4,2),[0;1;0;2]);
B = AffFunction(randn(3,2),[0;-1;-2]);
Y.addFunction(A,'saluva');
Y.addFunction(B,'echaz');

Y.fplot('saluva');

h = Y.fplot('echaz');
if isempty(h)
    error('Handle should not be empty.');
end

close all

end
