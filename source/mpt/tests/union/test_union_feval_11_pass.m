function test_union_feval_11_pass
% arrays of unions, vector-valued functions, no tiebreak

f1 = @(x) [x; x];
f2 = @(x) [x^2; x^3];
f3 = @(x) [0.1; 0.1];
g1 = @(x) 20;
g2 = @(x) 10;
g3 = @(x) x;
P1 = Polyhedron('lb', -1, 'ub', 1.5);
P2 = Polyhedron('lb', 2, 'ub', 3);
P1.addFunction(f1, 'f');
P1.addFunction(g1, 'g');
P2.addFunction(f2, 'f');
P2.addFunction(g2, 'g');
U1 = Union;
U1.add(P1);
U1.add(P2);

Q1 = Polyhedron('lb', -1, 'ub', 1.3);
Q2 = Polyhedron('lb', 1, 'ub', 4);
Q3 = Polyhedron('lb', 1.5, 'ub', 2.5);
Q1.addFunction(f1, 'f');
Q2.addFunction(f2, 'f');
Q3.addFunction(f3, 'f');
U2 = Union;
U2.add(Q1);
U2.add(Q2);
U2.add(Q3);

U = [U1 U2];

% point in multiple regions
x = 2;
% non-scalar in uniform output
[worked, msg] = run_in_caller('f=U.forEach(@(u) u.feval(x, ''f''));');
assert(~worked);
asserterrmsg(msg, 'Non-scalar in Uniform output');
% with correct option
f = U.forEach(@(u) u.feval(x, 'f'), 'UniformOutput', false);
assert(iscell(f));
assert(numel(f)==2);
assert(isequal(f{1}, f2(x)));
assert(isequal(f{2}, [f2(x), f3(x)]));

% point in a single region of U2, not in U1
x = 4;
% non-scalar in uniform output
[worked, msg] = run_in_caller('f=U.forEach(@(u) u.feval(x, ''f''));');
assert(~worked);
asserterrmsg(msg, 'Non-scalar in Uniform output');
% with correct option
f = U.forEach(@(u) u.feval(x, 'f'), 'UniformOutput', false);
assert(iscell(f));
assert(numel(f)==2);
assert(isequal(size(f{1}), [2 1]));
assert(all(isnan(f{1})));
assert(isequal(f{2}, f2(x)));

% point in single region of U2, U1
x = -1;
[worked, msg] = run_in_caller('f=U.forEach(@(u) u.feval(x, ''f''));');
% non-scalar in uniform output
assert(~worked);
asserterrmsg(msg, 'Non-scalar in Uniform output');
% with correct option
f = U.forEach(@(u) u.feval(x, 'f'), 'UniformOutput', false);
assert(iscell(f));
assert(numel(f)==2);
assert(isequal(f{1}, f1(x)));
assert(isequal(f{2}, f1(x)));

% test multiple outputs

% point in a single region of U2, not in U1
x = 4; 
[f, feasible, idx, tb_value] = U.forEach(@(u) u.feval(x, 'f'), 'UniformOutput', false);
assert(iscell(f));
assert(numel(f)==2);
assert(isequal(size(f{1}), [2 1]));
assert(all(isnan(f{1})));
assert(isequal(f{2}, f2(x)));
assert(iscell(feasible));
assert(numel(feasible)==2);
assert(feasible{1}==false);
assert(feasible{2}==true);
assert(iscell(idx));
assert(numel(idx)==2);
assert(isempty(idx{1}));
assert(idx{2}==2);
assert(iscell(tb_value));
assert(numel(tb_value)==2);
assert(isempty(tb_value{1}));
assert(isempty(tb_value{2}));

% point in multiple regions
x = 2;
[f, feasible, idx, tb_value] = U.forEach(@(u) u.feval(x, 'f'), 'UniformOutput', false);
assert(iscell(f));
assert(numel(f)==2);
assert(isequal(f{1}, f2(x)));
assert(isequal(f{2}, [f2(x), f3(x)]));
assert(iscell(feasible));
assert(numel(feasible)==2);
assert(feasible{1}==true);
assert(feasible{2}==true);
assert(iscell(idx));
assert(numel(idx)==2);
assert(idx{1}==2);
assert(isequal(idx{2}, [2 3]));
assert(iscell(tb_value));
assert(numel(tb_value)==2);
assert(isempty(tb_value{1}));
assert(isempty(tb_value{2}));
