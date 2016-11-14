function test_mpt_mplp_02_pass

Double_Integrator; probStruct.norm = 1; probStruct.P_N = zeros(2);
model = mpt_import(sysStruct, probStruct);
M = MPCController(model, 2);
Y = M.toYALMIP;

[mpsol, diag, z, hpwf, zpwf] = solvemp(Y.constraints, Y.objective, sdpsettings('debug', 1), ...
	Y.variables.x(:, 1), Y.variables.u(:, 1));
assert(~isempty(mpsol));
assert(~isempty(mpsol{1}));
assert(length(mpsol{1}.Pn)==12);

O = Opt(Y.constraints, Y.objective, Y.variables.x(:, 1), Y.variables.u(:));
plcpsol = O.solve;
assert(length(plcpsol.xopt.Set)==12);

P = toPolyhedron(mpsol{1}.Pn);
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
