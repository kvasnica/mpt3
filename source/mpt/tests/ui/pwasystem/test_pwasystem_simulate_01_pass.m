function test_pwasystem_simulate_01_pass
% tests PWASystem/simulate() with a non-autonomous system

opt_sincos;
P = PWASystem(sysStruct);

x0 = [2;2];
U = [1 0.5 0.3 -1 -0.4];
X = [2 2;-0.585640646055102 3.1856406460551;1.97282032302755 2.18;-0.721220174989041 2.53881001347527;1.4704511036459 0.515200000000001;0.231239411034565 0.82483840862417]';
Y = X(:, 1:end-1);

P.initialize(x0);
D = P.simulate(U);

assert(norm(D.X-X)<1e-12);
assert(norm(D.U-U)<1e-12);
assert(norm(D.Y-Y)<1e-12);

end

