function test_mpt_mpqp_05_pass

Double_Integrator
model = mpt_import(sysStruct, probStruct);
M = MPCController(model, 3);
Y = M.toYALMIP;
O = Opt(Y.constraints, Y.objective, Y.variables.x(:, 1), Y.variables.u(:));
% force the MPQP solver
O.solver = 'mpqp';

T = evalc('sol = O.solve;');
disp(T);
% make sure mpt_mpqp_26 was really called
assert(~isempty(findstr(T, 'mpt_mpqp:')));
assert(~isempty(findstr(T, 'Calling mpt_mpqp')));

assert(length(sol.xopt.Set)==19);
assert(isa(sol.xopt.Set, 'Polyhedron'));

% check correctness of the feasible set
H = sortrows(double(sol.mpqpsol.Phard));
Hgood = [-1 0 5;-0.203610055929218 -0.979052064562708 1.86032121572301;0.203610055929218 0.979052064562708 1.86032121572301;1 0 5];
assert(norm(H-Hgood)<1e-8);

% make sure the domain was returned
assert(isa(sol.xopt.Domain, 'Polyhedron'));
assert(length(sol.xopt.Domain)==1);
assert(sol.xopt.Internal.convexHull == sol.xopt.Domain);

end
