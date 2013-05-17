function test_polyunion_feval_02_pass
%
% three sets, overlaps
%

P1 = Polyhedron('lb', 0, 'ub', 1);
P2 = Polyhedron('lb', 0.5, 'ub', 2);
P3 = Polyhedron('lb', 0.8, 'ub', 3);
A = rand(1);
f1 = @(x) x;
f2 = @(x) x^2;
f3 = @(x) x^3;
P1.addFunction(f1, 'f');
P2.addFunction(f2, 'f');
P3.addFunction(f3, 'f');
U = PolyUnion([P1 P2 P3]);

% point outside
x = -1;
f = U.feval(x);
assert(isscalar(f));
assert(isnan(f));
[f, feasible, idx, tb_value]  = U.feval(x);
assert(~feasible);
assert(isempty(idx));
assert(isempty(tb_value));

% x in single region
x = 0.1;
assert(isequal(U.feval(x), f1(x)));
[f, feasible, idx, tb_value] = U.feval(x);
assert(isequal(f, f1(x)));
assert(feasible);
assert(idx==1);
assert(isempty(tb_value));

% x in multiple regions, no tiebreak
x = 0.9;
f = U.feval(x);
assert(isequal(f, [f1(x), f2(x), f3(x)]));
[f, feasible, idx, tb_value] = U.feval(x);
assert(isscalar(feasible));
assert(feasible);
assert(isequal(idx, [1 2 3]));
assert(isempty(tb_value));

% x in multiple regions, tiebreak (last region)
x = 0.9;
tb_fun = @(x) -double(toc);
f = U.feval(x, 'tiebreak', tb_fun);
assert(isequal(f, f3(x)));
[f, feasible, idx, tb_value] = U.feval(x, 'tiebreak', tb_fun);
assert(isscalar(feasible));
assert(feasible);
assert(isequal(idx, 3));

end
