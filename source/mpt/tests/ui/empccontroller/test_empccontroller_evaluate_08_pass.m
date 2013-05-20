function test_empccontroller_evaluate_08_pass
% stress-test EMPCController/evaluate with a single optimizer

Double_Integrator
model = mpt_import(sysStruct, probStruct);
E = EMPCController(model, probStruct.N);
assert(E.nr==25);

% only points in the optimizer
X = E.optimizer.convexHull.grid(40);
assert(size(X, 1)==1178);
t=clock;
for i = 1:size(X, 1),
	u = E.evaluate(X(i, :)');
end,
etime(clock, t)

% also points outside
X = E.optimizer.convexHull.outerApprox().grid(40);
assert(size(X, 1)==1600);
t=clock;
for i = 1:size(X, 1),
	u = E.evaluate(X(i, :)');
end,
etime(clock, t)

end
