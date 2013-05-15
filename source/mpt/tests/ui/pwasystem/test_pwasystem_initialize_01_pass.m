function test_pwasystem_initialize_01_pass
% tests PWASystem/initialize()

opt_sincos;
L = PWASystem(sysStruct);
assert(L.nx==size(sysStruct.A{1}, 1));

% freshly created system should not be initialized
assert(isempty(L.getStates));

x0 = randn(L.nx, 1);
L.initialize(x0);
assert(isequal(L.getStates, x0));

end

