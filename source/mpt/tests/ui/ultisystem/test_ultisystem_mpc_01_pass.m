function test_ultisystem_mpc_01_pass
% MPC synthesis based on ULTISystems with additive disturbances

%% double integrator with +/- 0.5 disturbances
sys = ULTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
sys.x.min = [-5; -5];
sys.x.max = [5; 5];
sys.x.penalty = QuadFunction(eye(2));
sys.u.min = -1;
sys.u.max = 1;
sys.u.penalty = QuadFunction(1);
sys.d.min = [-0.5; -0.5];
sys.d.max = [0.5; 0.5];
% simple MPC without any terminal constraints
N = 3;
ctrl = MPCController(sys, N);
x0 = [4.5; 0]; Nsim = 10;
d = ctrl.simulate(x0, Nsim);
assert(isfield(d, 'D')); % must be returned by ClosedLoop/simulate
assert(size(d.D, 2)==Nsim);
u0exp = -1;
assert(norm(d.U(:, 1)-u0exp)<1e-8); % first input is independent of the diturbance
% explicit MPC should also work
ectrl = ctrl.toExplicit();
assert(ectrl.optimizer.Num==9);
% expected domain:
E = Polyhedron('H', [-1 0 4.5;1 0 4.5;-0.707106781186547 -0.707106781186548 3.88908729652601;0 -1 4.5;-0.447213595499958 -0.894427190999916 3.13049516849971;-0.316227766016838 -0.948683298050514 3.00416377715996;0.707106781186547 0.707106781186548 3.88908729652601;0.316227766016838 0.948683298050514 3.00416377715996;0 1 4.5;0.447213595499958 0.894427190999916 3.13049516849971]);
assert(ectrl.optimizer.Domain==E);

%% same but with terminal set
sys.x.with('terminalSet');
sys.x.terminalSet = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
% sys.x.terminalSet = Polyhedron('lb', [-5; -5], 'ub', [5; 5]);
ctrl = MPCController(sys, N);
ectrl = ctrl.toExplicit();
assert(ectrl.optimizer.Num==31);
% expected domain:
E = Polyhedron('H', [1 0 4.5;-1 0 4.5;-0.707106781186547 -0.707106781186547 3.18198051533946;-0.316227766016838 -0.948683298050514 1.73925271309261;0.316227766016838 0.948683298050514 1.73925271309261;0.707106781186547 0.707106781186547 3.18198051533946;0 -1 2.5;0.707106781186548 -0.707106781186548 4.59619407771256;0 1 2.5;-0.707106781186548 0.707106781186548 4.59619407771256]);
assert(ectrl.optimizer.Domain==E);

end
