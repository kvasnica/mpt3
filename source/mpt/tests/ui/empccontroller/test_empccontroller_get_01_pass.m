function test_empccontroller_get_01_pass
% tests get.feedback, get.cost, get.partition

model = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
model.x.max = 5; model.x.min = -5;
model.u.max = 1; model.u.min = -1;

% mpqp
model.x.penalty = QuadFunction(1);
model.u.penalty = QuadFunction(1);
E = EMPCController(model, 2);
E.display();
assert(E.nr==3);
assert(numel(E.optimizer)==1);
assert(isa(E.optimizer, 'PolyUnion'));
% EMPCController/get.feedback should copy the polyunion's properties if we
% have just a single optimizer
assert(E.partition.Internal.Convex==1);

assert(isa(E.feedback, 'PolyUnion'));
assert(isa(E.cost, 'PolyUnion'));
assert(isa(E.partition, 'PolyUnion'));

% check that correct functions were extracted
F = E.feedback.Set;
C = E.cost.Set;
S = E.optimizer.Set;
for i = 1:length(E.optimizer.Set)
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
