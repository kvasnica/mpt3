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
assert(~isempty(strfind(msg, 'Input must be a Penalty object.')));

% penalty matrix must have correct number of columns
P = Penalty([1 0 1], 1);
[worked, msg] = run_in_caller('u.penalty = P;');
assert(~worked);
assert(~isempty(strfind(msg, 'The weighting matrix must have 2 columns.')));

% penalty matrix must be square for 2-norms
P = Penalty([1 1], 2);
[worked, msg] = run_in_caller('u.penalty = P;');
assert(~worked);
assert(~isempty(strfind(msg, 'The weighting matrix must be square.')));

% input penalties must be positive definite (2-norm):
P = Penalty([1 0; 0 0], 2);
[worked, msg] = run_in_caller('u.penalty = P;');
assert(~worked);
assert(~isempty(strfind(msg, 'The weighting matrix must be positive definite.')));

% state penalties must be positive semi-definite (2-norm):
P = Penalty([1 0; 0 -1], 2);
[worked, msg] = run_in_caller('x.penalty = P;');
assert(~worked);
assert(~isempty(strfind(msg, 'The weighting matrix must be positive semi-definite.')));

end
