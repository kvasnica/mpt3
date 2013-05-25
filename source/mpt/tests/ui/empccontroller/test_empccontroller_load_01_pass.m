function test_empccontroller_load_01_pass
% tests EMPCController/loadobj a EMPCController/saveobj


L = LTISystem('A', 1, 'B', 2);
L.x.min = -5; L.x.max = 5; L.u.min = -0.2; L.u.max = 0.3;
L.x.penalty = QuadFunction(1); 
L.u.penalty = QuadFunction(1);

M = EMPCController(L, 3);
assert(isa(M.optimizer, 'PolyUnion'));
[~, ~, openloop] = M.evaluate(1);
ugood = openloop.U;
save mpc_saved M
clear M
load mpc_saved
assert(isa(M, 'EMPCController'));
assert(isa(M.optimizer, 'PolyUnion'));
assert(M.optimizer.Num==5);
assert(isa(M.partition, 'PolyUnion'));
assert(isa(M.cost, 'PolyUnion'));
assert(isa(M.feedback, 'PolyUnion'));
assert(M.cost.hasFunction('obj'));
assert(~M.cost.hasFunction('primal'));
assert(M.feedback.hasFunction('primal'));
assert(~M.feedback.hasFunction('obj'));
assert(M.nr==5);


[~, ~, openloop] = M.evaluate(1);
assert(norm(openloop.U-ugood)<1e-10);
% sdpvars should be restored on load
assert(isa(M.model.x.var, 'sdpvar'));

% remove mpc_saved.mat
if exist(['.' filesep 'mpc_saved.mat'], 'file')
	delete(['.' filesep 'mpc_saved.mat']);
end

end
