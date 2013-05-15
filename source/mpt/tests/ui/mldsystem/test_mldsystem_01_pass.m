function test_mldsystem_01_pass
% tests empty constructor

L = MLDSystem;
assert(isempty(L.A));
assert(isempty(L.B1));
assert(isempty(L.E5));
assert(isempty(L.S));

end

