function test_enum_pqp_01
% region-based mpt_enum_pqp

% remember the original solver and set it back when the function ends
m = mptopt;
pqp_solver = m.pqpsolver;
c = onCleanup(@() mptopt('pqpsolver', pqp_solver));
mptopt('pqpsolver', 'enumpqp');

Double_Integrator
model = mpt_import(sysStruct, probStruct);
N = 4;
ctrl = MPCController(model, N);
d = ctrl.toYALMIP();

% direct call to mpt_enum_pqp
pqp = Opt(d.constraints, d.objective, d.internal.parameters, d.variables.u(:));
pqp.eliminateEquations();
sol = mpt_enum_pqp(pqp);
assert(isequal(sol.how, 'ok'));
assert(sol.exitflag==1);
assert(sol.xopt.Num==23);
assert(iscell(sol.stats.Aoptimal));
assert(length(sol.stats.Aoptimal)==5);
assert(isequal(cellfun('length', sol.stats.Aoptimal), [1 6 8 4 4]));
assert(isequal(cellfun('length', sol.stats.Afeasible), [1 14 68 140 4]));
assert(isequal(cellfun('length', sol.stats.Ainfeasible), [0 2 23 10 128]));
assert(sol.stats.nLPs==595);
assert(isa(sol.xopt.Set(1), 'Polyhedron')); % must be region-based

% % now via Opt/solve - does not require manual elimination of equalities
% pqp = Opt(d.constraints, d.objective, d.internal.parameters, d.variables.u(:));
% sol = solve(pqp);
% assert(isequal(sol.how, 'ok'));
% assert(sol.exitflag==1);
% assert(sol.xopt.Num==23);
% assert(iscell(sol.stats.Aoptimal));
% assert(length(sol.stats.Aoptimal)==5);
% assert(isequal(cellfun('length', sol.stats.Aoptimal), [1 6 8 4 4]));
% assert(isequal(cellfun('length', sol.stats.Afeasible), [1 14 68 140 4]));
% assert(isequal(cellfun('length', sol.stats.Ainfeasible), [0 2 23 10 128]));
% assert(sol.stats.nLPs==595);
% assert(isa(sol.xopt.Set(1), 'Polyhedron')); % must be region-based

end
