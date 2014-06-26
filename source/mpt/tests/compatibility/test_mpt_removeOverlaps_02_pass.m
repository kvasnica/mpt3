function test_mpt_removeOverlaps_02_pass
% providing a single, non-overlapping partition must work

Double_Integrator
probStruct.Tconstraint = 0;
probStruct.N = 2;
ctrl = mpt_control(sysStruct, probStruct, 'online');
Y = ctrl.toYALMIP();
sol = solvemp(Y.constraints, Y.objective, [], Y.internal.parameters, Y.variables.u(:, 1));

out = mpt_removeOverlaps(sol);
assert(isa(out.Pn, 'polytope'));
assert(length(out.Pn)==3);

end
