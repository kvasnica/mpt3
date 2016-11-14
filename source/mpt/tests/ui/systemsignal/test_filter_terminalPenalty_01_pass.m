function test_filter_terminalPenalty_01_pass
% tests SystemSignal/filter_terminalPenalty

x = SystemSignal(2);
x.userData.kind = 'x';
% signals shouldn't have the terminalPenalty filter active by default
assert(~x.hasFilter('terminalPenalty'));

% add the filter
x.with('terminalPenalty');

% set empty penalty
x.terminalPenalty = [];

% 2-norm, positive semi-definite weight
Q = [1 0; 0 0]; n = 2;
x.terminalPenalty = QuadFunction(Q);
assert(isequal(x.terminalPenalty.weight, Q));
assert(isa(x.terminalPenalty, 'QuadFunction'));

% 2-norm, positive definite weight
Q = [1 0; 0 1]; n = 2;
x.terminalPenalty = QuadFunction(Q);
assert(isequal(x.terminalPenalty.weight, Q));

% 1-norm, square penalty
Q = [1 0; 0 0]; n = 1;
x.terminalPenalty = OneNormFunction(Q);
assert(isequal(x.terminalPenalty.weight, Q));

% 1-norm, non-square penalty
Q = [1 0]; n = 1;
x.terminalPenalty = OneNormFunction(Q);
assert(isequal(x.terminalPenalty.weight, Q));

end
