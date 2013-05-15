function test_empccontroller_get_02_pass
% tests get.feedback, get.cost, get.partition with multiple optimizers

% mpMILP from YALMIP
opt_sincos; probStruct.N = 2;
model = mpt_import(sysStruct, probStruct);
M = MPCController(model, probStruct.N);
E = M.toExplicit;

assert(numel(E.optimizer)==4);
F = E.feedback;
C = E.cost;
P = E.partition;
assert(isa(P, 'PolyUnion'));
assert(P.Num==E.nr);

for i = 1:length(E.optimizer)
	assert(isa(E.optimizer(i), 'PolyUnion'));
	assert(isa(F(i), 'PolyUnion'));
	assert(isa(C(i), 'PolyUnion'));
end

% check that correct functions were extracted
for j = 1:numel(E.optimizer)
	F = E.feedback(j).Set;
	C = E.cost(j).Set;
	S = E.optimizer(j).Set;
	for i = 1:length(E.optimizer(j).Set)
		% primal
		Fprimal = F(i).getFunction('primal');
		Sprimal = S(i).getFunction('primal');
		assert(isequal(Fprimal.F, Sprimal.F));
		assert(isequal(Fprimal.g, Sprimal.g));
		% obj
		Cobj = C(i).getFunction('obj');
		Sobj = S(i).getFunction('obj');
		assert(isequal(Cobj.F, Sobj.F));
		assert(isequal(Cobj.g, Sobj.g));
	end
end


end
