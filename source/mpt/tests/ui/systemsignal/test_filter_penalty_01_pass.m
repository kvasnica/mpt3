function test_filter_penalty_01_pass
% tests SystemSignal/validatePenalty()

u = SystemSignal(2);
if ~u.hasFilter('penalty')
	u.with('penalty');
end
u.userData.kind = 'u';

x = SystemSignal(2);
if ~x.hasFilter('penalty')
	x.with('penalty');
end
x.userData.kind = 'x';

% setting empty penalties should work
u.penalty = [];
x.penalty = [];
assert(isempty(u.penalty));
assert(isempty(x.penalty));

% 1-norm / non-square weight
Q = [1 0]; n = 1;
u.penalty = Penalty(Q, n);
assert(isequal(u.penalty.Q, Q));
assert(isequal(u.penalty.norm, n));

% Inf-norm / non-square weight
Q = [1 0]; n = Inf;
u.penalty = Penalty(Q, n);
assert(isequal(u.penalty.Q, Q));
assert(isequal(u.penalty.norm, n));

% 1-norm / square weight
Q = [1 0; 0 0]; n = 1;
u.penalty = Penalty(Q, n);
assert(isequal(u.penalty.Q, Q));
assert(isequal(u.penalty.norm, n));

% 2-norm / input (positive definite weight)
Q = [1 0; 0 1]; n = 2;
u.penalty = Penalty(Q, n);
assert(isequal(u.penalty.Q, Q));
assert(isequal(u.penalty.norm, n));

% 2-norm / state (positive semi-definite weight)
Q = [1 0; 0 0]; n = 2;
x.penalty = Penalty(Q, n);
assert(isequal(x.penalty.Q, Q));
assert(isequal(x.penalty.norm, n));

end
