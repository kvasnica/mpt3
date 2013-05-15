function test_mpccontroller_load_01_pass
% tests MPCController/loadobj a MPCController/saveobj


L = LTISystem('A', 1, 'B', 2);
L.x.min = -1; L.x.max = 1; L.u.min = -2; L.u.max = 3;
L.x.penalty = Penalty(1, 2); L.u.penalty = Penalty(1, 2);

% save/load a controller without optimizer
M = MPCController(L, 3);
assert(isempty(M.optimizer));
save mpc_saved M
clear M
load mpc_saved
assert(isa(M, 'MPCController'));
assert(isempty(M.optimizer));
clear M

% save/load a controller with optimizer (the optimizer should not be saved)
M = MPCController(L, 4);
assert(isempty(M.optimizer));
assert(isequal(M.model.B, 2));
M.evaluate(1); % this creates the optimizer
assert(isobject(M.optimizer));
save mpc_saved M
clear M
load mpc_saved
assert(isempty(M.optimizer));
% variables should have been uninstantiated in AbstractController/saveobj
assert(isa(M.model.x.var, 'sdpvar')); % sdpvars should be restored on load
[~, ~, openloop] = M.evaluate(1); % this creates the optimizer
assert(isa(M.optimizer, 'optimizer'));
ugood = [-0.414201183431953 -0.0710059171597633 -0.0118343195266272 0];
assert(norm(openloop.U-ugood)<1e-8);
save mpc_saved M
clear M
load mpc_saved
% values of sdpvars should be restored on load
assert(norm(M.model.u.value-ugood)<1e-8);

% save/load a controller with custom YALMIP setup (obj.yalmipData should
% not be saved);
M = MPCController(L, 4);
assert(isempty(M.yalmipData));
Y = M.toYALMIP;
M.fromYALMIP(Y);
assert(isa(M.optimizer, 'optimizer')) % fromYALMIP() should create the optimizer
assert(isstruct(M.yalmipData));
save mpc_saved M
clear M
load mpc_saved
assert(isa(M, 'MPCController'));
assert(isempty(M.optimizer));
assert(isempty(M.yalmipData)); % YALMIP data cannot be saved
% sdpvars should be restored
assert(isa(M.model.x.var, 'sdpvar'));
[u, ~, openloop] = M.evaluate(1); % this creates the optimizer
ugood = [-0.414201183431953 -0.0710059171597633 -0.0118343195266272 0];
assert(norm(u-ugood(:, 1))<1e-8);
assert(norm(openloop.U-ugood)<1e-8);
clear M

% remove mpc_saved.mat
if exist(['.' filesep 'mpc_saved.mat'], 'file')
	delete(['.' filesep 'mpc_saved.mat']);
end

end
