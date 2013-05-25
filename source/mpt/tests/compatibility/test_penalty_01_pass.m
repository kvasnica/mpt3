function test_penalty_01_pass
% Penalty should be mapped to functions

Q = randn(2);

% squared two-norm
n = 2;
P = Penalty(Q, n);
assert(isa(P, 'QuadFunction'));
assert(isequal(P.weight, Q));

% 1-norm
n = 1;
P = Penalty(Q, n);
assert(isa(P, 'OneNormFunction'));
assert(isequal(P.weight, Q));

% inf-norm
n = Inf;
P = Penalty(Q, n);
assert(isa(P, 'InfNormFunction'));
assert(isequal(P.weight, Q));

% 0-norm
n = 0;
P = Penalty(Q, n);
assert(isa(P, 'AffFunction'));
assert(isequal(P.weight, Q));

end
