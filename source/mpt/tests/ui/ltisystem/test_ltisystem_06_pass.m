function test_ltisystem_06_pass
% import from sysStruct

Double_Integrator
sysStruct.xmax = [2; 3];
sysStruct.xmin = [-4; -5];
nx = size(sysStruct.A, 1); 
nu = size(sysStruct.B, 2);
ny = size(sysStruct.C, 1);

L = LTISystem(sysStruct);

assert(isequal(L.A, sysStruct.A));
assert(isequal(L.B, sysStruct.B));
assert(isequal(L.C, sysStruct.C));
assert(isequal(L.D, sysStruct.D));
assert(isequal(L.f, zeros(nx, 1)));
assert(isequal(L.g, zeros(ny, 1)));
assert(isequal(L.nx, nx));
assert(isequal(L.nu, nu));
assert(isequal(L.ny, ny));
assert(isequal(L.u.min, sysStruct.umin))
assert(isequal(L.u.max, sysStruct.umax))
assert(isequal(L.x.min, sysStruct.xmin))
assert(isequal(L.x.max, sysStruct.xmax))
assert(isequal(L.y.min, sysStruct.ymin))
assert(isequal(L.y.max, sysStruct.ymax))

end

