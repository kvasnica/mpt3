function test_mldsystem_toPWA_01_pass
% tests export to PWA

% system with binary inputs
L = MLDSystem('turbo_car');
P = L.toPWA;
assert(P.nx==3);
assert(P.nu==2);
assert(P.ny==1);
assert(P.ndyn==2);
assert(isequal(P.d.binary, 1:P.ndyn));
assert(isequal(P.x.max, [50; 10; 5]));
assert(isequal(P.x.min, [-50; -10; 0]));
assert(isequal(P.u.max, [1; 1]));
assert(isequal(P.u.min, [-1; 0]));
assert(isequal(P.A{1}, [1 1 0;0 1 0;0 0 1]));
assert(isequal(P.A{2}, [1 1 0;0 1 0;0 0 1]));
assert(isequal(P.B{1}, [1 0;0.5 0;0 0]));
assert(isequal(P.B{2}, [2 0;1 0;0 0]));
assert(isequal(P.C{1}, [1 0 0]));
assert(isequal(P.C{2}, [1 0 0]));
assert(isequal(P.f{1}, [0; 0; 0]));
assert(isequal(P.f{2}, [0; 0; -1]));
assert(isequal(P.g{1}, 0));
assert(isequal(P.g{2}, 0));
assert(isequal(P.D{1}, [0 0]));
assert(isequal(P.D{2}, [0 0]));
assert(isequal(P.domain(1).H, [0 0 0 0 1 0.5]));
assert(isequal(P.domain(2).H, [0 0 0 0 -1 -0.5]));

% make sure inputs were marked as binary
assert(P.u.hasFilter('binary'));
assert(isequal(P.u.binary, 2));

% system without binary inputs
L = MLDSystem('pwa_car');
P = L.toPWA;
assert(P.nx==2);
assert(P.nu==1);
assert(P.ny==2);
assert(P.ndyn==4);
assert(isequal(P.d.binary, 1:P.ndyn));
assert(isequal(P.x.max, [1; 40]));
assert(isequal(P.x.min, [-7; -40]));
assert(isequal(P.u.max, 5));
assert(isequal(P.u.min, -5));
assert(~P.u.hasFilter('binary'));
assert(isequal(P.A{1}, [1 0.1;0 1]));
assert(isequal(P.A{2}, [1 0.1;0 1]));
assert(isequal(P.A{3}, [1 0.1;0 1]));
assert(isequal(P.A{4}, [1 0.1;0 1]));
assert(isequal(P.B{1}, [0.005;0.1]));
assert(isequal(P.B{2}, [0.005;0.1]));
assert(isequal(P.B{3}, [0.005;0.1]));
assert(isequal(P.B{4}, [0.005;0.1]));
assert(isequal(P.C{1}, [1 0;0 1]));
assert(isequal(P.C{2}, [1 0;0 1]));
assert(isequal(P.C{3}, [1 0;0 1]));
assert(isequal(P.C{4}, [1 0;0 1]));
assert(isequal(P.f{1}, [0;0]));
assert(isequal(P.f{2}, [-0.02568;-1.703489]));
assert(isequal(P.f{3}, [0;0]));
assert(isequal(P.f{4}, [0.01541;0.854998]));
assert(isequal(P.g{1}, [0; 0]));
assert(isequal(P.g{2}, [0; 0]));
assert(isequal(P.g{3}, [0; 0]));
assert(isequal(P.g{4}, [0; 0]));
assert(isequal(P.D{1}, [0; 0]));
assert(isequal(P.D{2}, [0; 0]));
assert(isequal(P.D{3}, [0; 0]));
assert(isequal(P.D{4}, [0; 0]));

end

