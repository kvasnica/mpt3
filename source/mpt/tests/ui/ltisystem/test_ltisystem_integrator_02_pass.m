function test_ltisystem_integrator_02_pass
% tests LTISystem/filter_integrator

% output tracking / state penalties
L = LTISystem('A', [1 1; 0.2 1], 'B', [1; 0.5], 'C', [1 0]);
L.x.penalty = QuadFunction(eye(2));
L.u.penalty = QuadFunction(1);
L.y.with('reference');
L.y.reference = 'free';
L.with('integrator');
mpc = MPCController(L, 10);
x0 = [3; 0];
yref = 1.2;
[~, ~, ol] = mpc.evaluate(x0, 'y.reference', yref);
Jgood = 4.77433789364016;
Ugood = [-1.06788766025492 -0.502786734203154 -0.378512204887875 -0.382391260896097 -0.411816387035478 -0.437972890040984 -0.45588174913204 -0.467075093748251 -0.474219719063823 -0.48];
assert(abs(ol.cost-Jgood)<=1e-6);
assert(norm(ol.U-Ugood, Inf)<=1e-6);

% output tracking / output penalties
L = LTISystem('A', [1 1; 0.2 1], 'B', [1; 0.5], 'C', [1 0]);
L.y.penalty = QuadFunction(1);
L.u.penalty = QuadFunction(1);
L.y.with('reference');
L.y.reference = 'free';
L.with('integrator');
mpc = MPCController(L, 10);
x0 = [3; 0];
yref = 1.2;
[~, ~, ol] = mpc.evaluate(x0, 'y.reference', yref);
Jgood = 4.22078563711067;
Ugood = [-1.06788766025492 -0.502786734203154 -0.378512204887875 -0.382391260896097 -0.411816387035478 -0.437972890040984 -0.45588174913204 -0.467075093748251 -0.474219719063823 -0.48];
assert(abs(ol.cost-Jgood)<=1e-6);

% state tracking
L = LTISystem('A', [1 1; 0.2 1], 'B', [1; 0.5], 'C', [1 0]);
L.x.penalty = QuadFunction(eye(2));
L.u.penalty = QuadFunction(1);
L.x.with('reference');
L.x.reference = 'free';
L.with('integrator');
mpc = MPCController(L, 10);
x0 = [3; 0];
xref = [1.2; 0.48];
[~, ~, ol] = mpc.evaluate(x0, 'x.reference', xref);
Jgood = 4.77433789364016;
Ugood = [-1.06788766025492 -0.502786734203154 -0.378512204887875 -0.382391260896097 -0.411816387035478 -0.437972890040984 -0.45588174913204 -0.467075093748251 -0.474219719063823 -0.48];
assert(abs(ol.cost-Jgood)<=1e-6);
assert(norm(ol.U-Ugood, Inf)<=1e-6);

% infeasible state reference (not steady-state)
xref = [1.2; 0];
[~, feasible, ol] = mpc.evaluate(x0, 'x.reference', xref);
assert(~feasible);

end
