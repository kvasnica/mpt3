function test_convexset_fplot_03_fail
%
% function over 3D set cannot be plotted
%

x = sdpvar(3,1);
F1 = set(-[1;3;4]<x<[5;3;4]) + set(0.5*x'*x<0.2) + set(randn(1,3)*x<0.5);
F2 = set(-[1;3;1]<x<[5;2;4]) + set(0.1*rand(1)*x'*x<0.2) + set(randn(1,3)*x<0.5);
Y1 = YSet(x,F1,sdpsettings('verbose',0));
Y2 = YSet(x,F1,sdpsettings('verbose',0));
Y = [Y1;Y2];

A = AffFunction(randn(4,3),[0;1;0;2]);
B = AffFunction(randn(3,3),[0;-1;-2]);
Y.addFunction(A,'a');
Y.addFunction(B,'b');

try
    Y.fplot
catch
    close all
    error('ok');
end

end