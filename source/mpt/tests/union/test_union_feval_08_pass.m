function test_union_feval_08_pass
%
% nooverlaps, polycomplex
%

% only V-rep
P = ExamplePoly.randVrep('d',3);
T= P.triangulate;
T.addFunction(Function(@(x) 1./(1+x.^2)),'f1');
T.addFunction(Function(@(x) sin(x)./(1+cos(x).^2)),'f2');
T.addFunction(Function(@(x) x.*sin(x)./(1+cos(x).^2)),'f3');
U = Union(T);
f1 = @(x) 1./(1+x.^2);
f2 = @(x) sin(x)./(1+cos(x).^2);
f3 = @(x) x.*sin(x)./(1+cos(x).^2);

F1 = [];
F2 = [];
F3 = [];
W = [];
for j = 1:numel(T)
	V = T(j).V;
	V = [V; T(j).interiorPoint.x'];
	W = [W; V];
	for i = 1:size(V, 1)
		x = V(i, :)';
		F1 = [F1 U.feval(x, 'f1', 'tiebreak', @(x) 0)];
		F2 = [F2 U.feval(x, 'f2', 'tiebreak', @(x) 0)];
		F3 = [F3 U.feval(x, 'f3', 'tiebreak', @(x) 0)];
		assert(isequal(F1(:, end), f1(x)));
		assert(isequal(F2(:, end), f2(x)));
		assert(isequal(F3(:, end), f3(x)));
	end
end

% also H-rep
T.minHRep();
T.addFunction(Function(@(x) 1./(1+x.^2)),'f1');
T.addFunction(Function(@(x) sin(x)./(1+cos(x).^2)),'f2');
T.addFunction(Function(@(x) x.*sin(x)./(1+cos(x).^2)),'f3');
U = Union(T);
f1 = @(x) 1./(1+x.^2);
f2 = @(x) sin(x)./(1+cos(x).^2);
f3 = @(x) x.*sin(x)./(1+cos(x).^2);

for i = 1:size(W, 1)
	x = W(i, :)';
	assert(isequal(U.feval(x, 'f1', 'tiebreak', @(x) 0), F1(:, i)));
	assert(isequal(U.feval(x, 'f2', 'tiebreak', @(x) 0), F2(:, i)));
	assert(isequal(U.feval(x, 'f3', 'tiebreak', @(x) 0), F3(:, i)));
end
