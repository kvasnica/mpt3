function test_mldsystem_update_03_pass
% tests MLDSystem/update with HYSDEL3 MLD structure

pwa_car_h3
L = MLDSystem(S);
x0 = [-5; 0];
L.initialize(x0);

u = 5;
xgood = [-4.95959;1.354998];
ygood = [-5; 0];
[xn, y] = L.update(u);
assert(norm(xn-xgood)<1e-8);
assert(norm(y-ygood)<1e-8);

u = 5;
xgood = [-4.7836802;2.709996];
ygood = [-4.95959;1.354998];
[xn, y] = L.update(u);
assert(norm(xn-xgood)<1e-8);
assert(norm(y-ygood)<1e-8);

u = 0;
xgood = [-4.4972706;3.564994];
ygood = [-4.7836802;2.709996];
[xn, y] = L.update(u);
assert(norm(xn-xgood)<1e-8);
assert(norm(y-ygood)<1e-8);

x0 = [-2; 6];
u = 5;
L.initialize(x0);
xgood = [-1.40068;4.796511];
ygood = [-2; 6];
zgood = [-0;-0.02568;-0;-1.703489];
dgood = [0;1;1;1;1];
[xn, y, z, d] = L.update(u);
assert(norm(xn-xgood)<1e-8);
assert(norm(y-ygood)<1e-8);
assert(norm(z-zgood)<1e-8);
assert(norm(d-dgood)<1e-8);

end
