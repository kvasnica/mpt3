function test_convexset_fplot_11_pass
%
% 2D set, one function, return with and without handle
%

x = sdpvar(2,1);
F = [-[1;3]<=x<=[5;4]] + [0.5*x'*x<=0.2] + [randn(1,2)*x<=0.5];

Y = YSet(x,F,sdpsettings('verbose',0));

A = AffFunction(randn(4,2),[0;1;0;2]);
Y.addFunction(A,'saluva');

Y.fplot('saluva');

h = Y.fplot;
if isempty(h)
    error('Handle should not be empty.');
end

close all

end
