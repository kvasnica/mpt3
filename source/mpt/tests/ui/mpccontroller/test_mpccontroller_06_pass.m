function test_mpccontroller_06_pass
% tests that we correctly recognized uninitiallized prediction horizons

L = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
L.x.max = 5;
L.x.min = -4;
L.u.max = 3;
L.u.min = -2;

% basic syntax with just the model, should set N=[]
M = MPCController(L);
assert(isempty(M.N));

% methods which should require a prediction horizon
methods = {'toExplicit', 'evaluate(1)', 'toYALMIP', 'construct'};
for i = 1:length(methods)
	[works, T] = run_in_caller(['M.' methods{i} ';']);
	assert(~works);
	assert(~isempty(findstr(T, 'The prediction horizon must be specified.')));
end

% the methods should work again once the horizon is set
M.N = 1;
for i = 1:length(methods)
	[works, T] = run_in_caller(['M.' methods{i} ';']);
	assert(works);
end

end
