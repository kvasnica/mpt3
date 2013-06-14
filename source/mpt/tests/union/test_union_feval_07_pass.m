function test_union_feval_07_pass
% Ysets, overlapping regions, single function

x = sdpvar(2,1);
A = [1 -0.2; 0.4 -1];
F = [(norm(A*x-[1;1])<=2) ; ( [1 -2]*x<=0.4 )];
G = (-1.5<=x <=3);

Y(1) = YSet(x,F).addFunction(AffFunction(2*eye(2),[1;-1]), 'f');
Y(2) = YSet(x,G).addFunction(AffFunction(3*eye(2),[-1;1]), 'f');

U = Union(Y);
P = Polyhedron('Ae',[-1 1],'be',-1.5);
P.addFunction(AffFunction(4*eye(2),[1;1]), 'f');
U.add(P);

% not tie-break by default
x = [1; 1];
y = U.feval(x);
assert(isequal(y, [U.Set{1}.Func{1}.feval(x), ...
	U.Set{2}.Func{1}.feval(x)]));

% first-region tiebreak
x = [1; 1];
y = U.feval(x, 'tiebreak', @(x) 0);
assert(isequal(y, U.Set{1}.Func{1}.feval(x)));

% point in the intersection of lowdim with fulldim (Y(1), Y(2) and P),
% first-region tiebreak
x = [2.7; 1.2];
[y, ~, ~, tb_value] = U.feval(x);
assert(isequal(y, [U.Set{1}.Func{1}.feval(x), ...
	U.Set{2}.Func{1}.feval(x), P.Func{1}.feval(x)]));
assert(isempty(tb_value));
% explicit no tiebreak
x = [2.7; 1.2];
[y, ~, ~, tb_value] = U.feval(x, 'tiebreak', []);
assert(isequal(y, [U.Set{1}.Func{1}.feval(x), ...
	U.Set{2}.Func{1}.feval(x), P.Func{1}.feval(x)]));
assert(isempty(tb_value));
% last-region tiebreak
x = [2.7; 1.2];
[y, ~, ~, tb_value] = U.feval(x, 'tiebreak', @(x) -double(tic));
assert(isequal(y, U.Set{end}.Func{1}.feval(x)));
assert(isnumeric(tb_value));
assert(isscalar(tb_value));
% first-region tiebreak
x = [2.7; 1.2];
[y, ~, ~, tb_value] = U.feval(x, 'tiebreak', @(x) 1.12);
assert(isequal(y, Y(1).Func{1}.feval(x)));
assert(tb_value==1.12);
