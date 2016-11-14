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
u.penalty = OneNormFunction(Q);
assert(isequal(u.penalty.weight, Q));

% Inf-norm / non-square weight
Q = [1 0]; n = Inf;
u.penalty = InfNormFunction(Q);
assert(isequal(u.penalty.weight, Q));

% 1-norm / square weight
Q = [1 0; 0 0]; n = 1;
u.penalty = OneNormFunction(Q);
assert(isequal(u.penalty.weight, Q));

% 2-norm / input (positive definite weight)
Q = [1 0; 0 1]; n = 2;
u.penalty = QuadFunction(Q);
assert(isequal(u.penalty.weight, Q));

% 2-norm / state (positive semi-definite weight)
Q = [1 0; 0 0]; n = 2;
x.penalty = QuadFunction(Q);
assert(isequal(x.penalty.weight, Q));

end
