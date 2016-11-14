function test_union_feval_02_pass
%
% empty unions
%

% union with empty set
U = Union;
[fval, feasible, idx] = feval(U, []);
assert(isempty(fval));
assert(~feasible);
assert(isempty(idx));

% empty array
Q = U([]);
[fval, feasible, idx] = feval(Q, []);
assert(isempty(fval));
assert(~feasible);
assert(isempty(idx));


end
