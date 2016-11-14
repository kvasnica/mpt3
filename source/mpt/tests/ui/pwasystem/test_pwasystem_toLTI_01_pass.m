function test_pwasystem_toLTI_01_pass
% tests LTISystem/toLTI

nu = 2; nx = 3; ny = 4; Ts = 1.5; L = {}; ndyn = 4;

for i = 1:ndyn
	A = randn(nx); B = randn(nx, nu);
	C = randn(ny, nx); D = randn(ny, nu);
	L{i} = LTISystem('A', A, 'B', B, 'C', C, 'D', D, 'Ts', Ts);
end

P = PWASystem([L{:}]);
P.x.max = rand(nx, 1);
P.u.min = -rand(nu, 1);

for i = 1:ndyn
	S = P.toLTI(i);
	assert(isa(S, 'LTISystem'));
	assert(isequal(S.A, P.A{i}));
	assert(isequal(S.B, P.B{i}));
	assert(isequal(S.C, P.C{i}));
	assert(isequal(S.D, P.D{i}));
	assert(isequal(S.f, P.f{i}));
	assert(isequal(S.g, P.g{i}));
	assert(isequal(S.x.max, P.x.max));
	assert(isequal(S.x.min, P.x.min));
	assert(isequal(S.u.max, P.u.max));
	assert(isequal(S.u.min, P.u.min));
	assert(isequal(S.y.max, P.y.max));
	assert(isequal(S.y.min, P.y.min));
	assert(isequal(S.Ts, P.Ts));
end

end

