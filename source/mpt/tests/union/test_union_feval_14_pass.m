function test_union_feval_14_pass
% test evaluation only over selected regions

U = Union;
funs = {};
for i = 1:4
	p = Polyhedron('lb', i, 'ub', i+1);
	funs{i} = @(x) i;
	p.addFunction(funs{i}, 'fun');
	U.add(p);
end
x = -10;
regions = [1 4];

% evaluation must pass even if the point is not in the union
[f, feasible, idx, tb_value] = U.feval(x, 'regions', regions);
assert(feasible);
assert(isequal(f, [funs{regions(1)}(x), funs{regions(2)}(x)]));
assert(isequal(idx, regions));
assert(isempty(tb_value));

% tie-breaking must not influence region selection
[f, feasible, idx, tb_value] = U.feval(x, 'tiebreak', @(x) 0, 'regions', regions);
assert(feasible);
assert(isequal(f, [funs{regions(1)}(x), funs{regions(2)}(x)]));
assert(isequal(idx, regions));
assert(isempty(tb_value));
