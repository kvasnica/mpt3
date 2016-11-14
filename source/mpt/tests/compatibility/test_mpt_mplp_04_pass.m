function test_mpt_mplp_04_pass
% test Opt.solve with the mplp solver

% this tests passes (12 regions) with CDD as an LP solver:
%   mptopt('lpsolver', 'cdd');

Double_Integrator; probStruct.norm = 1;
model = mpt_import(sysStruct, probStruct);
M = MPCController(model, 2);
Y = M.toYALMIP;
O = Opt(Y.constraints, Y.objective, Y.variables.x(:, 1), Y.variables.u(:));
% force the MPLP solver
O.solver = 'mpLP';

T = evalc('sol = O.solve;');
disp(T);

assert(length(sol.xopt.Set)==28);
% make sure mpt_mplp_26 was really called
assert(~isempty(findstr(T, 'mpt_mplp:')));
% make sure the domain was returned
assert(isa(sol.xopt.Domain, 'Polyhedron'));
assert(length(sol.xopt.Domain)==1);
assert(sol.xopt.Internal.convexHull == sol.xopt.Domain);

end
