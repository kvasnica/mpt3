function test_mldsystem_02_pass
% tests import from hysdel

L = MLDSystem('pwa_car');
assert(L.nx==2);
assert(L.nu==1);
assert(L.ny==2);
assert(L.nz==4);
assert(L.nd==5);
assert(L.d.hasFilter('binary'));
assert(isequal(L.d.binary, 1:L.nd));
assert(isequal(L.x.max, [1; 40]));
assert(isequal(L.x.min, [-7; -40]));
assert(isequal(L.u.max, 5));
assert(isequal(L.u.min, -5));
assert(isstruct(L.S));
assert(isequal(size(L.A), [2 2]));
assert(isequal(size(L.B1), [2 1]));
assert(isequal(size(L.B2), [2 5]));
assert(isequal(size(L.B3), [2 4]));
assert(isequal(size(L.B5), [2 1]));
assert(isequal(size(L.C), [2 2]));
assert(isequal(size(L.D1), [2 1]));
assert(isequal(size(L.D2), [2 5]));
assert(isequal(size(L.D3), [2 4]));
assert(isequal(size(L.D5), [2 1]));
assert(isequal(size(L.E1), [20 1]));
assert(isequal(size(L.E2), [20 5]));
assert(isequal(size(L.E3), [20 4]));
assert(isequal(size(L.E4), [20 2]));
assert(isequal(size(L.E5), [20 1]));

end

