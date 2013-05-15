function test_mptctrl_load_01_pass
% test loading of explicit controllers

% finite-horizon explicit MPC
load expctrl
assert(isa(ctrl, 'EMPCController'));
assert(ctrl.nr()==25);
assert(numel(ctrl.optimizer)==1);
assert(ctrl.nx==2);
assert(ctrl.nu==1);
assert(ctrl.N==5);
assert(isequal(ctrl.model.A, [1 1; 0 1]));

% finite-horizon on-line MPC
load onlctrl
assert(isa(ctrl, 'MPCController'));
assert(ctrl.nx==2);
assert(ctrl.nu==1);
assert(ctrl.N==5);
assert(isequal(ctrl.model.A, [1 1; 0 1]));

% infinite-horizon explicit MPC, we should give a warning
load infctrl
assert(isa(ctrl, 'EMPCController'));
assert(ctrl.nx==2);
assert(ctrl.nu==1);
assert(ctrl.N==1); % should be set by mptctrl/loadobj
assert(isequal(ctrl.model.A, [1 1; 0 1]));

% explicit minimum-time MPC
load mintimectrl
assert(isa(ctrl, 'EMinTimeController'));
assert(ctrl.nx==2);
assert(ctrl.nu==1);
assert(ctrl.N==1); % should be set by mptctrl/loadobj
assert(isequal(ctrl.model.A, [1 1; 0 1]));

end
