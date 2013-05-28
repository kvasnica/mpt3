function test_empccontroller_evaluate_11_pass
% stress-test EMPCController/evaluate with a single optimizer and tie
% breaking

% same as test_empccontroller_evaluate_08_pass, but with 1-norm cost, which
% induces lots of tie breaking. here the evaluation used to be slow

sys = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
sys.x.min = [-5; -5]; sys.x.max = [5; 5];
sys.u.min = -1; sys.u.max = 1;
sys.x.penalty = OneNormFunction(eye(2));
sys.u.penalty = QuadFunction(1);
E = EMPCController(sys, 3);
assert(E.nr==58);

% only points in the optimizer
X = E.optimizer.convexHull.grid(40);
assert(size(X, 1)==1014);
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
