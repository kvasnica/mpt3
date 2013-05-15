function test_convexset_fplot_15_pass
%
% two 2D set, two functions, plot based on a string and index and various
% colors
%

x = sdpvar(2,1);
F1 = set(-[1;3]<=x<=[5;4]) + set(0.5*x'*x<=0.2) + set(randn(1,2)*x<=0.5);
F2 = set(-[1;3]<=x<=[5;4]) + set(0.1*rand(1)*x'*x<=0.2) + set(randn(1,2)*x<=0.5);
Y1 = YSet(x,F1,sdpsettings('verbose',0));
Y2 = YSet(x,F1,sdpsettings('verbose',0));
Y = [Y1;Y2];

A = AffFunction(randn(4,2),[0;1;0;2]);
B = AffFunction(randn(3,2),[0;-1;-2]);
Y.addFunction(A,'saluva');
Y.addFunction(B,'echaz');

Y(1).fplot('saluva',2,'alpha',0.3,'color','g','grid',30);

h = Y(2).fplot('echaz',3,'contour',true,'polyhedron',true);
if isempty(h)
    error('Handle should not be empty.');
end

close all

end
