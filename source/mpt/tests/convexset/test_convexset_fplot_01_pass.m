function test_convexset_fplot_01_pass
%
% 1D set, one function
%

x = sdpvar(1);
F = set(-1<=x<=5) + set(0.5*x^2<=0.2);

Y = YSet(x,F,sdpsettings('verbose',0));
Y.addFunction(Function(@(x) log(x+2)), 'f');
h=Y.fplot;

if isempty(h)
   error('Must be handle here.');
end
close
end
