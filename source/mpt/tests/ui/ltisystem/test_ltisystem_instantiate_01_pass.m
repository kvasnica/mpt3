function test_ltisystem_instantiate_01_pass
% tests AbstractSystem/instantiate with filters which respond to
% instantiate()

L = LTISystem('A', 1, 'B', 2);
L.x.with('softMax');
L.x.with('softMin');
L.instantiate(1);
assert(isa(L.x.internal_properties.soft_max, 'sdpvar'));
assert(isa(L.x.internal_properties.soft_min, 'sdpvar'));

% now uninstantiate
L.uninstantiate();
assert(isempty(L.x.internal_properties.soft_max));
assert(isempty(L.x.internal_properties.soft_min));

end
