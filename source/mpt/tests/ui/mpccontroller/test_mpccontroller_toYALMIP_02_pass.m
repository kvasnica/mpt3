function test_mpccontroller_toYALMIP_02_pass

A = [1 1; 0 1];
B = [1; 0.5];
lti = LTISystem('A', A, 'B', B, 'C', [1 0]);
lti.x.min = [-5; -5];
lti.x.max = [5; 5];
lti.u.min = -1;
lti.u.max = 1;
lti.x.penalty = QuadFunction(0.1*eye(2));
lti.u.penalty = QuadFunction(1);
ctrl = MPCController(lti, 10);

% no additional varibales
data = ctrl.toYALMIP();
assert(isfield(data.variables, 'x'));
assert(isfield(data.variables, 'u'));
assert(isfield(data.variables, 'y'));
assert(~isfield(data.variables, 'auto'));

% soft constraints introduce additional variables
ctrl.model.x.with('softMax');
ctrl.model.u.with('softMin');
ctrl.model.u.with('softMax');
data = ctrl.toYALMIP();
assert(isfield(data.variables, 'x'));
assert(isfield(data.variables, 'u'));
assert(isfield(data.variables, 'y'));
assert(isfield(data.variables, 'filters')); % variables introduced by filters
assert(isfield(data.variables.filters, 'x'));
assert(isfield(data.variables.filters, 'u'));
assert(~isfield(data.variables.filters, 'y'));
assert(isfield(data.variables.filters.x, 'softMax'));
assert(~isfield(data.variables.filters.x, 'softMin'));
assert(isa(data.variables.filters.x.softMax, 'sdpvar'));
assert(isfield(data.variables.filters.u, 'softMax'));
assert(isfield(data.variables.filters.u, 'softMin'));
assert(isa(data.variables.filters.u.softMax, 'sdpvar'));
assert(isa(data.variables.filters.u.softMin, 'sdpvar'));

end
