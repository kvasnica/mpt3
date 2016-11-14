function test_closedloop_toSystem_01_pass
% LTI system + EMPC controller = PWA system

model = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
model.x.min = -5;
model.x.max = 5;
model.u.min = -1;
model.u.max = 1;
model.x.penalty = QuadFunction(1);
model.u.penalty = QuadFunction(1);
M = MPCController(model, 2).toExplicit;
assert(M.nr==3);

CL = ClosedLoop(M, model);
S = CL.toSystem;

assert(isa(S, 'PWASystem'));
assert(numel(S.A)==M.nr);
assert(S.ndyn==M.nr);
for i = 1:numel(S.B)
	% check that the system is really autonomous
	assert(isempty(S.B{i}));
	assert(isempty(S.D{i}));
end

end
