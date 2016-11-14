function test_pwasystem_02_pass
% tests import from sysStruct

pwa_DI;
nx = 2; nu = 1; ny = 2;
L = PWASystem(sysStruct);

assert(iscell(L.A));
assert(iscell(L.B));
assert(iscell(L.C));
assert(iscell(L.D));
assert(iscell(L.f));
assert(iscell(L.g));
assert(L.nu==nu);
assert(L.nx==nx);
assert(L.ny==ny);
assert(L.ndyn==length(sysStruct.A));
assert(length(L.A)==L.ndyn);
assert(length(L.B)==L.ndyn);
assert(length(L.C)==L.ndyn);
assert(length(L.D)==L.ndyn);
assert(length(L.f)==L.ndyn);
assert(length(L.g)==L.ndyn);
assert(isa(L.domain, 'Polyhedron'));
assert(numel(L.domain)==L.ndyn);
assert(isa(L.domainx, 'Polyhedron'));
assert(numel(L.domainx)==L.ndyn);

% check that matrices have been correctly propagated
f = {'A', 'B', 'C', 'D', 'f', 'g'};
for j = 1:length(f)
	f1 = sysStruct.(f{j});
	f2 = L.(f{j});
	for i = 1:length(f1)
		assert(isequal(f1{i}, f2{i}));
	end
end

% check signals
assert(L.d.n==L.ndyn);
assert(L.d.hasFilter('binary'));
assert(isequal(L.d.binary(:), (1:L.ndyn)'));

assert(isequal(L.x.max, Inf(nx, 1)));
assert(isequal(L.x.min, -Inf(nx, 1)));
assert(isequal(L.u.max, sysStruct.umax));
assert(isequal(L.u.min, sysStruct.umin));
assert(isequal(L.y.max, sysStruct.ymax));
assert(isequal(L.y.min, sysStruct.ymin));

% check domain
for i = 1:length(sysStruct.guardX)
	A = [sysStruct.guardX{i} zeros(size(sysStruct.guardX{i}, 1), nu)];
	Dxu = Polyhedron('A', A, 'b', sysStruct.guardC{i});
	Dx = Polyhedron('A', sysStruct.guardX{i}, 'b', sysStruct.guardC{i});
	assert(Dxu==L.domain(i));
	assert(Dx==L.domainx(i));
end

end

