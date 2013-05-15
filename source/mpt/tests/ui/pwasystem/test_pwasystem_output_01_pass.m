function test_pwasystem_output_01_pass
% tests PWASystem/output()

opt_sincos;
sysStruct.C{1} = [2 0; 0 2];
P = PWASystem(sysStruct);

x0 = -[2; 2];
P.initialize(x0);
y = P.output;
assert(isequal(y, 2*x0)); % C=2*I in dynamics 1

x0 = [2; 2];
P.initialize(x0);
y = P.output;
assert(isequal(y, x0)); % C=I in dynamics 1

end

