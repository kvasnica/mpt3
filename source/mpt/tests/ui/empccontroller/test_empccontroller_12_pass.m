function test_empccontroller_12_pass
% ctrl.partition.Domain must be set correctly

% LTI system
model = LTISystem('A', 1.4, 'B', 1);
model.x.min = -5; model.x.max = 5;
model.u.min = -1; model.u.max = 1;
model.x.penalty = QuadFunction(1);
model.u.penalty = QuadFunction(1);
ctrl = EMPCController(model, 2);

% the domain must be a single polyhedron
assert(ctrl.partition.Num==5);
assert(isa(ctrl.partition.Domain, 'Polyhedron'));
assert(length(ctrl.partition.Domain)==1);
Vexpected = [3.77551020408163;-3.77551020408163];
assert(norm(ctrl.partition.Domain.V - Vexpected) < 1e-8);

% PWA system
mode_1 = LTISystem('A', 1.4, 'B', 1);
mode_2 = LTISystem('A', -0.9, 'B', 1);
mode_1.setDomain('x', Polyhedron('lb', 0));
mode_2.setDomain('x', Polyhedron('ub', 0));
pwa = PWASystem([mode_1, mode_2]);
pwa.x.min = -5; pwa.x.max = 5;
pwa.u.min = -1; pwa.u.max = 1;
pwa.x.penalty = QuadFunction(1);
pwa.u.penalty = QuadFunction(1);
ctrl = EMPCController(pwa, 2);

% the domain must be composed of 4 polyhedra
assert(ctrl.partition.Num==7);
assert(isa(ctrl.partition.Domain, 'Polyhedron'));
assert(length(ctrl.partition.Domain)==4);

end
