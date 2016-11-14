function test_opt_feasibleset_03_pass

Double_Integrator;
probStruct.Tconstraint = 0;
M = mpt_constructMatrices(sysStruct, probStruct);
pqp = Opt(M);

% wrong projection method
[~, msg] = run_in_caller('K = pqp.feasibleSet(''bogus'');');
asserterrmsg(msg, 'Supported methods are');

% wrong type of the input
[~, msg] = run_in_caller('K = pqp.feasibleSet(true);');
asserterrmsg(msg, 'The input must be either a string or an array of Polyhedron objects.');

% different projection method
T = evalc('K = pqp.feasibleSet(''mplp'');');
assert(isempty(T));

% default projection method (fourier)
T = evalc('S = pqp.feasibleSet();');
assert(~isEmptySet(S));

end
