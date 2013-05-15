function test_mldsystem_output_01_pass
% tests MLDSystem/output

L = MLDSystem('pwa_car');
x0 = [-5; 0];
L.initialize(x0);

u = 5;
ygood = [-5; 0];
y = L.output(u);
assert(norm(y-ygood)<1e-8);

end
