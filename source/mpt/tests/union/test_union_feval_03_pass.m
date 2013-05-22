function test_union_feval_03_pass
%
% union with a single function, no tiebreaking
%

% union with a single element
f1 = @(x) [x^2; x^3];
P1 = Polyhedron('lb', -1, 'ub', 2);
P1.addFunction(f1, 'fun');
U = Union;
U.add(P1);
x = 1.1;
f = U.feval(x);
assert(isequal(f, f1(x)));


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

% x not in the domain, must get [NaN; NaN]
x = -5;
f = U.feval(x);
assert(isequal(size(f), size(f1(x))));
assert(all(isnan(f)));
[f, feasible] = U.feval(x);
assert(isequal(size(f), size(f1(x))));
assert(all(isnan(f)));
assert(~feasible);
[f, feasible, idx] = U.feval(x);
assert(isequal(size(f), size(f1(x))));
assert(all(isnan(f)));
assert(~feasible)
assert(isempty(idx));
[f, feasible, idx, tie_value] = U.feval(x);
assert(isequal(size(f), size(f1(x))));
assert(all(isnan(f)));
assert(~feasible)
assert(isempty(idx));
assert(isempty(tie_value));

% x \in single region
x = 0.1;
f = U.feval(x);
assert(isequal(f, f1(x)));
f = U.feval(x, 'fun');
assert(isequal(f, f1(x)));
[f, feasible, idx, tie_value] = U.feval(x, 'fun');
assert(feasible);
assert(isequal(f, f1(x)));
assert(idx==1);
assert(isempty(tie_value));

x = 2.1;
f = U.feval(x);
assert(isequal(f, f2(x)));
f = U.feval(x, 'fun');
assert(isequal(f, f2(x)));
[f, feasible, idx, tie_value] = U.feval(x);
assert(feasible);
assert(isequal(f, f2(x)));
assert(idx==2);
assert(isempty(tie_value));

% x in multiple regions, no tiebreak
x = 2;
f = U.feval(x);
assert(isequal(f, [f1(x), f2(x)]));
[f, feasible, idx, tie_value] = U.feval(x);
assert(feasible);
assert(isequal(f, [f1(x), f2(x)]));
assert(isequal(idx, [1 2]));
assert(isempty(tie_value));

end
