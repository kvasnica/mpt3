function test_union_feval_05_pass
%
% tie-breaking

f1 = @(x) [x; x];
f2 = @(x) [x^2; x^3];
g1 = @(x) 20;
g2 = @(x) 10;
P1 = Polyhedron('lb', -1, 'ub', 2);
P2 = Polyhedron('lb', 2, 'ub', 3);
P1.addFunction(f1, 'f');
P1.addFunction(g1, 'g');
P2.addFunction(f2, 'f');
P2.addFunction(g2, 'g');
U = Union;
U.add(P1);
U.add(P2);

% x \in single region (just test that the tiebreak option does not corrupt
% anything)
x = 0.1;
f = U.feval(x, 'f', 'tiebreak', 'g');
assert(isequal(f, f1(x)));
f = U.feval(x, 'g', 'tiebreak', @(x) x);
assert(isequal(f, g1(x)));
f = U.feval(x, 'g', 'tiebreak', []);
assert(isequal(f, g1(x)));
[f, feasible, idx] = U.feval(x, 'f', 'tiebreak', 'g');
assert(feasible);
assert(isequal(f, f1(x)));
assert(idx==1);

x = 2.1;
f = U.feval(x, 'f', 'tiebreak', @(x) x^2);
assert(isequal(f, f2(x)));
f = U.feval(x, 'g', 'tiebreak', []);
assert(isequal(f, g2(x)));
f = U.feval(x, 'g', 'tiebreak', 'g');
assert(isequal(f, g2(x)));
[f, feasible, idx] = U.feval(x, 'g', 'tiebreak', @(x) 0);
assert(feasible);
assert(isequal(f, g2(x)));
assert(idx==2);

% x in multiple regions, no tiebreak by default
x = 2;
[f, feasible, idx, tb_value] = U.feval(x, 'f');
assert(feasible);
assert(isequal(f, [f1(x) f2(x)]));
assert(isequal(idx, [1 2]));
assert(isempty(tb_value));

% x in multiple regions, custom tiebreak (associated function)
x = 2;
[f, feasible, idx, tb_value] = U.feval(x, 'f', 'tiebreak', 'g');
assert(feasible);
assert(isequal(f, f2(x)));
assert(isequal(idx, 2));
assert(isequal(tb_value, U.Set{2}.Functions('g').Handle(x)));

% x in multiple regions, custom tiebreak (anonymoys function)
x = 2;
% @(x) -double(tic) = last-region tiebreak
[f, feasible, idx] = U.feval(x, 'f', 'tiebreak', @(x) -double(tic));
assert(feasible);
assert(isequal(f, f2(x)));
assert(isequal(idx, 2));
x = 2;
% @(x) constant = first-region tiebreak
[f, feasible, idx, tb_value] = U.feval(x, 'f', 'tiebreak', @(x) -2.22);
assert(feasible);
assert(isequal(f, f1(x)));
assert(isequal(idx, 1));
assert(tb_value==-2.22);

% non-scalar tie-breaking must be rejected
[~, msg] = run_in_caller('U.feval(x, ''f'', ''tiebreak'', @(x) [1; 1])');
asserterrmsg(msg, 'The tie breaker must be a scalar-valued function.');
