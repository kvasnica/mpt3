function test_opt_solve_01_pass
% solving a parametric problem for a particular parameter

%% QP
clear sysStruct probStruct
Double_Integrator
probStruct.N = 2;
probStruct.Tconstraint = 0;
M = mpt_constructMatrices(sysStruct, probStruct);
P = Opt(M);
assert(isequal(P.problem_type, 'QP'));
sol_parametric = P.solve();
% check feasible parameters
X = sol_parametric.xopt.convexHull.grid(10);
for i = 1:size(X, 1)
	x = X(i, :)';
	obj_p = sol_parametric.xopt.feval(x, 'obj', 'tiebreak', 'obj');
	obj_np = P.solve(x).obj;
	assert(abs(obj_p - obj_np) < 1e-6);
end

%% LP
clear sysStruct probStruct
Double_Integrator
probStruct.norm = 1;
probStruct.N = 2;
M = mpt_constructMatrices(sysStruct, probStruct);
P = Opt(M);
assert(isequal(P.problem_type, 'LP'));
sol_parametric = P.solve();
% check feasible parameters
X = sol_parametric.xopt.convexHull.grid(10);
for i = 1:size(X, 1)
	x = X(i, :)';
	obj_p = sol_parametric.xopt.feval(x, 'obj', 'tiebreak', 'obj');
	obj_np = P.solve(x).obj;
	assert(abs(obj_p - obj_np) < 1e-6);
end

%% LCP
clear sysStruct probStruct
Double_Integrator
probStruct.Tconstraint = 0;
probStruct.N = 2;
M = mpt_constructMatrices(sysStruct, probStruct);
P = Opt(M);
P.qp2lcp();
assert(isequal(P.problem_type, 'LCP'));
sol_parametric = P.solve();
% check feasible parameters
X = sol_parametric.xopt.convexHull.grid(10);
for i = 1:size(X, 1)
	x = X(i, :)';
	u_p = sol_parametric.xopt.feval(x, 'primal', 'tiebreak', 'obj');
	u_np = P.solve(x).obj;
	% TODO: recover cost and check its correctness
	% assert(abs(obj_p - obj_np) < 1e-6);
end

end
