function test_closedloop_tracking_01_pass

L = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
L.u.min = -1; L.u.max = 1;
L.x.min = [-5; -5]; L.x.max = [5;5];
L.u.penalty = QuadFunction(1);
L.x.penalty = QuadFunction(eye(2));
L.x.with('reference');
L.x.reference = 'free';
ctrl = MPCController(L, 2);

xref = [2;0];
x0 = [-1; 0];
Jgood = 24.768750024789;

d = ctrl.simulate(x0, 30, 'x.reference', xref);
assert(abs(sum(d.cost) - Jgood) <= 1e-8);
assert(isequal(d.X(:, 1), x0));
assert(norm(d.X(:, end)-xref) <= 1e-4);

E = EMPCController(L, 2);
assert(E.nr==17);
d = ctrl.simulate(x0, 30, 'x.reference', xref);
assert(abs(sum(d.cost) - Jgood) <= 1e-8);
assert(isequal(d.X(:, 1), x0));
assert(norm(d.X(:, end)-xref) <= 1e-4);

end
