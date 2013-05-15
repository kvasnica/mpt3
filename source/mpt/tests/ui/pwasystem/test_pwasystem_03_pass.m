function test_pwasystem_03_pass
% tests import from multiple LTISystems

opt_sincos;
S = sysStruct;
nx = 2; nu = 1; ny = 2;

L1 = LTISystem('A', S.A{1}, 'B', S.B{1}, 'C', S.C{1}, 'D', S.D{1});
L1.setDomain('x', Polyhedron('A', S.guardX{1}, 'b', S.guardC{1}));
L2 = LTISystem('A', S.A{2}, 'B', S.B{2}, 'C', S.C{2}, 'D', S.D{2});
L2.setDomain('x', Polyhedron('A', S.guardX{2}, 'b', S.guardC{2}));

L = PWASystem([L1 L2]);
L.u.max = S.umax;
L.u.min = S.umin;
L.y.max = S.ymax;
L.y.min = S.ymin;

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
f = {'A', 'B', 'C', 'D'};
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
	assert(L.domain(i)<=Dxu);
	assert(Dx==L.domainx(i));
end

end

