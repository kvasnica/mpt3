function test_polyhedron_unique_01_pass
% Tests ConvexSet/uniqueFunctions

N = 1;
Double_Integrator; probStruct.Tconstraint = 0; probStruct.P_N = eye(2);
model = mpt_import(sysStruct, probStruct);
E = EMPCController(model, N);
assert(E.nr==3);

% only existing functions can be trimmed
[worked, msg] = run_in_caller('E.optimizer.Set.uniqueFunctions(''nofunction'')');
assert(~worked);
assert(~isempty(strfind(msg, 'No such function "nofunction".')));
