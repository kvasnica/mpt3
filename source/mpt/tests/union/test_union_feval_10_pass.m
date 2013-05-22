function test_union_feval_10_pass
%
% test infeasibility

% union with multiple regions
f1 = @(x) [x; x];
f2 = @(x) [x^2; x^3];
P1 = Polyhedron('lb', -1, 'ub', 2);
P2 = Polyhedron('lb', 2, 'ub', 3);
P1.addFunction(f1, 'fun');
P2.addFunction(f2, 'fun');
U = Union;
U.add(P1);
U.add(P2);

x = 10; % point outside of the union

fval = U.feval(x);
assert(isequal(size(fval), [2 1]));
assert(all(isnan(fval)));

[fval, feasible, idx, tie_value] = U.feval(x);
assert(isequal(size(fval), [2 1]));
assert(all(isnan(fval)));
assert(~feasible);
assert(isempty(idx));
assert(isempty(tie_value));
