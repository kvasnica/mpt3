function test_empccontroller_evaluate_09_pass
% stress-test EMPCController/evaluate with multiple optimizers

opt_sincos; probStruct.N = 2; probStruct.norm = 2;
model = mpt_import(sysStruct, probStruct);
E = EMPCController(model, probStruct.N);
E.display();
assert(E.nr==10);
assert(numel(E.optimizer)==4);
X = PolyUnion(E.optimizer.convexHull).convexHull.grid(35);
assert(size(X, 1)==1209);

t=clock;
for i = 1:size(X, 1),
	u = E.evaluate(X(i, :)');
end,
etime(clock, t)

end
