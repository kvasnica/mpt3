function test_convexset_fplot_02_pass
%
% 1D set one function
%

x = sdpvar(1);
F = set(-1<=x<=5) + set(0.5*x^2<=0.2);

Y = YSet(x,F,sdpsettings('verbose',0));
A = AffFunction(5.6,-1);

Y.addFunction(A, 'f');
h1 = Y.fplot;
if isempty(h1)
    error('Handle must be returned.');
end
h2 = Y.plot;
if isempty(h2)
    error('Handle must be returned.');
end

close all;

end
