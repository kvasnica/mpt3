function test_mpccontroller_toYALMIP_03_pass
% test the PWAfunction filter

model = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
model.x.min = [-5; -5];
model.x.max = [5; 5];
model.u.min = -1;
model.u.max = 1;
model.x.penalty = OneNormFunction(eye(2));
model.u.penalty = OneNormFunction(1);
M = MPCController(model, 1);

% without the PWAfunction penalty
data_without = M.toYALMIP();
assert(~isfield(data_without.variables, 'filters'));

% prepare the polyunion to be employed as a PWA penalty
P1 = Polyhedron('lb', [0; 0], 'ub', [1; 1]);
P1.addFunction(AffFunction([1 1], 1), 'obj');
P2 = Polyhedron('lb', [0; 0], 'ub', [1; 1]);
P2.addFunction(AffFunction([1 1], 1), 'obj');
P = PolyUnion([P1 P2]);

% add the PWA penalty
model.x.with('PWApenalty');
model.x.PWApenalty.function = 'obj';
model.x.PWApenalty.isconvex = true;
model.x.PWApenalty.polyunion = P;
model.x.PWApenalty.step = 1;
M = MPCController(model, 1);
data_with = M.toYALMIP();
assert(isfield(data_with.variables, 'filters'));
assert(isfield(data_with.variables.filters.x, 'PWApenalty'));
% the epigraph variable must be an sdpvar
assert(isa(data_with.variables.filters.x.PWApenalty, 'sdpvar'));
% the epigraph variable must be a scalar
assert(numel(data_with.variables.filters.x.PWApenalty)==1);
% must have as many additional constraints as there are elements of the
% polyunion + one additional constraint for the covnex hull
assert(length(data_with.constraints)==length(data_without.constraints)+P.Num+1);

end
