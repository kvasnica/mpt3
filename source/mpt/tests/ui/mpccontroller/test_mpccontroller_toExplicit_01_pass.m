function test_mpccontroller_toExplicit_01_pass
% tests MPCController/toExplicit

Double_Integrator
probStruct.norm = 2;
probStruct.Tconstraint = 0; probStruct.P_N = eye(2);
model = mpt_import(sysStruct, probStruct);
M = MPCController(model, probStruct.N);
E = M.toExplicit();

assert(isa(E, 'EMPCController'));
assert(E.N==M.N);
assert(E.nr==21);

% check that we have broken references
xmax = M.model.x.max;
E.model.x.max = [6; 7];
assert(isequal(M.model.x.max, xmax));
M.model.x.max = [8; 9];
assert(isequal(E.model.x.max, [6; 7]));

end
