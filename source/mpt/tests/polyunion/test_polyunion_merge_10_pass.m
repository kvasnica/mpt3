function test_polyunion_merge_10_pass

N = 8; nu = 1; nx = 2;
Double_Integrator;
model = mpt_import(sysStruct, probStruct);
E = EMPCController(model, N);
assert(E.nr==31);

internal = E.optimizer.Internal;
F = E.optimizer.copy;
F.trimFunction('primal', nu);
funs = F.listFunctions;
% function name is required
[worked, msg] = run_in_caller('F.merge');
assert(~worked);
assert(~isempty(strfind(msg, 'Function name must be specified.')));

% in-place merging
F.merge('primal');
assert(F.Num==23);
assert(isequal(F.Internal, internal)); % internal properties should be the same
assert(isequal(F.listFunctions, funs)); % functions should be the same
% make sure each element of the set has all functions
for i = 1:length(F.Set)
	assert(isequal(F.Set(i).listFunctions, funs));
end

% asking for a new output
F = E.optimizer.copy;
F.trimFunction('primal', nu);
M = F.merge('primal');
assert(F.Num==31);
assert(M.Num==23);
assert(isequal(F.Internal, internal)); % internal properties should be the same
assert(isequal(F.listFunctions, funs)); % functions should be the same
assert(isequal(M.Internal, internal)); % internal properties should be the same
assert(isequal(M.listFunctions, funs)); % functions should be the same
% make sure each element of the set has all functions
for i = 1:length(F.Set)
	assert(isequal(F.Set(i).listFunctions, funs));
end
for i = 1:length(M.Set)
	assert(isequal(M.Set(i).listFunctions, funs));
end

% merging against open-loop optimizer should give the same number of
% regions
F = merge(E.optimizer.copy, 'primal');
assert(F.Num==E.optimizer.Num);
assert(isequal(E.optimizer.listFunctions, funs));
assert(isequal(F.Internal, internal)); % internal properties should be the same
assert(isequal(F.listFunctions, funs)); % functions should be the same
% make sure each element of the set has all functions
for i = 1:length(F.Set)
	assert(isequal(F.Set(i).listFunctions, funs));
end
