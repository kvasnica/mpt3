function test_union_feval_04_pass
%
% union with multiple functions, no tiebreaking
%

% union with a single element
f1 = @(x) [x^2; x^3];
f2 = @(x) sin(x);
P1 = Polyhedron('lb', -1, 'ub', 2);
P1.addFunction(f1, 'f1');
P1.addFunction(f2, 'f2');
U = Union;
U.add(P1);

% x \not\in domain
x = -5;
f = U.feval(x, 'f1');
assert(isequal(size(f), size(f1(x))));
assert(all(isnan(f)));
f = U.feval(x, 'f2');
assert(isequal(size(f), size(f2(x))));
assert(all(isnan(f)));

% x \in single region
x = 1.1;
f = U.feval(x, 'f1');
assert(isequal(f, f1(x)));
f = U.feval(x, 'f2');
assert(isequal(f, f2(x)));

% union with multiple regions
f1 = @(x) [x; x];
f2 = @(x) [x^2; x^3];
g1 = @(x) sin(x);
g2 = @(x) cos(x);
P1 = Polyhedron('lb', -1, 'ub', 2);
P2 = Polyhedron('lb', 2, 'ub', 3);
P1.addFunction(f1, 'f');
P1.addFunction(g1, 'g');
P2.addFunction(f2, 'f');
P2.addFunction(g2, 'g');
U = Union;
U.add(P1);
U.add(P2);

% x not in the domain, must get [NaN; NaN]
x = -5;
f = U.feval(x, 'f');
assert(isequal(size(f), size(f1(x))));
assert(all(isnan(f)));
[f, feasible] = U.feval(x, 'f');
assert(isequal(size(f), size(f1(x))));
assert(all(isnan(f)));
assert(~feasible);
[f, feasible, idx] = U.feval(x, 'f');
assert(isequal(size(f), size(f1(x))));
assert(all(isnan(f)));
assert(~feasible)
assert(isempty(idx));
[f, feasible, idx, tie_value] = U.feval(x, 'f');
assert(isequal(size(f), size(f1(x))));
assert(all(isnan(f)));
assert(~feasible)
assert(isempty(idx));
assert(isempty(tie_value));

% x \in single region
x = 0.1;
f = U.feval(x, 'f');
assert(isequal(f, f1(x)));
f = U.feval(x, 'g');
assert(isequal(f, g1(x)));
[f, feasible, idx, tb_value] = U.feval(x, 'f');
assert(feasible);
assert(isequal(f, f1(x)));
assert(idx==1);
assert(isempty(tb_value));

x = 2.1;
f = U.feval(x, 'f');
assert(isequal(f, f2(x)));
f = U.feval(x, 'g');
assert(isequal(f, g2(x)));
[f, feasible, idx, tb_value] = U.feval(x, 'g');
assert(feasible);
assert(isequal(f, g2(x)));
assert(idx==2);
assert(isempty(tb_value));

% x in multiple regions
x = 2;
f = U.feval(x, 'f');
assert(isequal(f, [f1(x), f2(x)]));
[f, feasible, idx, tb_value] = U.feval(x, 'g', 'tiebreak', []);
assert(feasible);
assert(isequal(f, [g1(x), g2(x)]));
assert(isequal(idx, [1 2]));
assert(isempty(tb_value));

% x in multiple regions, explicitly ask for no tiebreaking
x = 2;
f = U.feval(x, 'f', 'tiebreak', []);
assert(isequal(f, [f1(x), f2(x)]));
[f, feasible, idx, tb_value] = U.feval(x, 'g', 'tiebreak', []);
assert(feasible);
assert(isequal(f, [g1(x), g2(x)]));
assert(isequal(idx, [1 2]));
assert(isempty(tb_value));

end
