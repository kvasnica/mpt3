function test_polyhedron_unique_02_pass
% Tests ConvexSet/uniqueFunctions

N = 3; nu = 1; nx = 2;
Double_Integrator;
model = mpt_import(sysStruct, probStruct);
E = EMPCController(model, N);
assert(E.nr==19);

F = E.optimizer.trimFunction('primal', nu);
[funs, map] = F.Set.uniqueFunctions('primal');
assert(length(funs)==13);
assert(isequal(map, [1 2 3 4 5 6 7 2 2 3 3 8 9 10 11 2 3 12 13]));
for i = 1:F.Num
	f = F.Set(i).getFunction('primal');
	% are the functions really identical?
	assert(f==funs(map(i)))
	
	% check that no other function is identical
	for j = setdiff(1:length(funs), map(i))
		assert(f~=funs(j));
	end
end

end
