function test_convexset_fplot_14_pass
%
% 2D set, two functions, plot based on a string and index
%

x = sdpvar(2,1);
F = set(-[1;3]<=x<=[5;4]) + set(0.5*x'*x<=0.2) + set(randn(1,2)*x<=0.5);

Y = YSet(x,F,sdpsettings('verbose',0));

A = AffFunction(randn(4,2),[0;1;0;2]);
B = AffFunction(randn(3,2),[0;-1;-2]);
Y.addFunction(A,'saluva');
Y.addFunction(B,'echaz');

Y.fplot('saluva',2);

h = Y.fplot('echaz',3);
if isempty(h)
    error('Handle should not be empty.');
end
hn = Y.fplot();
if numel(hn)~=2
    error('Two handles should be here.');
end

close all

end
