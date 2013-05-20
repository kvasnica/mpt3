function test_pwasystem_toLTI_02_pass
%
% we must propagate signals of the PWA systems to individual LTI modes

L1 = LTISystem('A', eye(2), 'domain', Polyhedron([1 0], 0));
L2 = LTISystem('A', -eye(2), 'domain', Polyhedron([-1 0], 0));
L = [L1 L2];
P = PWASystem(L);

xmax = [1; 2];
P.x.max = xmax;
assert(isequal(P.x.max, xmax));
S1 = P.toLTI(1);
S2 = P.toLTI(2);
assert(isequal(S1.x.max, xmax));
assert(isequal(S2.x.max, xmax));

% change in "P" must automatically propagate to S1 and S2 even without
% calling toLTI
xmax = [2; 3];
P.x.max = xmax;
assert(isequal(P.x.max, xmax));
assert(isequal(S1.x.max, xmax));
assert(isequal(S2.x.max, xmax));

end
