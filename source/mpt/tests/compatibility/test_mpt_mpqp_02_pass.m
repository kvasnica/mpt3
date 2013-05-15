function test_mpt_mpqp_02_pass
% this test works fine with mptopt('qpsolver', 'quadprog')

Double_Integrator
model = mpt_import(sysStruct, probStruct);
M = MPCController(model, 3);
Y = M.toYALMIP;

[mpqpsol, diag, z, hpwf, zpwf] = solvemp(Y.constraints, Y.objective, sdpsettings('debug', 1), ...
	Y.variables.x(:, 1), Y.variables.u(:));
assert(~isempty(mpqpsol));
assert(~isempty(mpqpsol{1}));
assert(length(mpqpsol{1}.Pn)==19);

O = Opt(Y.constraints, Y.objective, Y.variables.x(:, 1), Y.variables.u(:));
plcpsol = O.solve;
assert(length(plcpsol.xopt.Set)==19);

P = toPolyhedron(mpqpsol{1}.Pn);
Q = plcpsol.xopt.Set;
assert(P==Q);

try
	plot(hpwf);
	plot(zpwf);
	close all
catch
	close all
	rethrow(lasterror);
end

end
