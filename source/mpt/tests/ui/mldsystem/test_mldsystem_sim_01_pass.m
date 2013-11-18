function test_mldsystem_sim_01_pass
% simulation with a HYSDEL3 MLD file without binaries

simple1_h3
S2=MLDSystem((S));

C2=MPCController(S2,2);
C2.model.x.penalty = OneNormFunction(([1]));
C2.model.y.penalty = OneNormFunction(([0.01]));
C2.model.u.penalty = OneNormFunction(diag([1e-8]));

loop = ClosedLoop(C2, S2);

% must not give an error
sim=loop.simulate([0.01],10);

Jexp = [0.012295000035 0 0 0 0 0 0 0 0 0];
assert(norm(sim.cost-Jexp, 1) < 1e-6);

end
