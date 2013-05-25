function test_filter_penalty_02_pass
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

% penalty must be an instance of @Penalty
Q = eye(u.n);
[worked, msg] = run_in_caller('u.penalty = Q;');
assert(~worked);
assert(~isempty(strfind(msg, 'Input must be a Function object.')));

% penalty matrix must have correct number of columns
P = OneNormFunction([1 0 1]);
[worked, msg] = run_in_caller('u.penalty = P;');
assert(~worked);
assert(~isempty(strfind(msg, 'The weighting matrix must have 2 column(s).')));

% penalty matrix must be square for 2-norms
[worked, msg] = run_in_caller('P = QuadFunction([1 1]);');
assert(~worked);
assert(~isempty(strfind(msg, 'The matrix "H" must be square.')));

% input penalties must be positive definite (2-norm):
P = QuadFunction([1 0; 0 0]);
[worked, msg] = run_in_caller('u.penalty = P;');
assert(~worked);
assert(~isempty(strfind(msg, 'The weighting matrix must be positive definite.')));

% state penalties must be positive semi-definite (2-norm):
P = QuadFunction([1 0; 0 -1]);
[worked, msg] = run_in_caller('x.penalty = P;');
assert(~worked);
assert(~isempty(strfind(msg, 'The weighting matrix must be positive semi-definite.')));

end
