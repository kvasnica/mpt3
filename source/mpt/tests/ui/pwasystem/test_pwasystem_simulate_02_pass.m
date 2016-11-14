function test_pwasystem_simulate_02_pass
% tests PWASystem/simulate() with an autonomous system

opt_sincos;
%sysStruct.A = { eye(2), -eye(2) };
sysStruct.B = { zeros(2, 0), zeros(2, 0) };
sysStruct.D = { zeros(2, 0), zeros(2, 0) };
sysStruct.umax = []; sysStruct.umin = [];
sysStruct = rmfield(sysStruct, 'dumax');
sysStruct = rmfield(sysStruct, 'dumin');
P = PWASystem(sysStruct);

x0 = [2;2];
U = zeros(0, 5);
X = [2 -0.585640646055102 1.28 -0.374810013475265 0.8192 -0.23987840862417;2 2.1856406460551 1.28 1.39881001347527 0.8192 0.89523840862417];
Y = X(:, 1:end-1);

P.initialize(x0);
D = P.simulate(U);

assert(norm(D.X-X)<1e-12);
assert(norm(D.U-U)<1e-12);
assert(norm(D.Y-Y)<1e-12);

end

