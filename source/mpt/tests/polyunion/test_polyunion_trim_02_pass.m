function test_polyunion_trim_02_pass
% Tests Union/trimFunction

N = 1;
Double_Integrator; probStruct.Tconstraint = 0; probStruct.P_N = eye(2);
model = mpt_import(sysStruct, probStruct);
E = EMPCController(model, N);
assert(E.nr==3);

% only existing functions can be trimmed
[worked, msg] = run_in_caller('E.optimizer.trimFunction(''nofunction'', 1)');
assert(~worked);
assert(~isempty(strfind(msg, 'No such function "nofunction".')));

% only affine functions can be trimmed
[worked, msg] = run_in_caller('E.optimizer.trimFunction(''obj'', 1)');
assert(~worked);
assert(~isempty(strfind(msg, 'Only affine functions can be trimmed.')));
