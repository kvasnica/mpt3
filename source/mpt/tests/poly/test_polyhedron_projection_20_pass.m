function test_polyhedron_projection_20_pass
% projection on unsorted dimensions must preserve the ordering (issue #101)

lb = [-1; -2; -3; -4; -5];
ub = [1; 2; 3; 4; 5];
P = Polyhedron('lb', lb, 'ub', ub);

dims_to_test = { 1, [1 3 5], [3 1], [4 3 2], [4 2 3] };

% test each method
methods = {'mplp', 'vrep', 'fourier'};
for j = 1:length(dims_to_test)
	dims = dims_to_test{j};
	Expected = Polyhedron('lb', lb(dims), 'ub', ub(dims));
	for i = 1:length(methods)
		R = P.projection(dims, methods{i});
		assert(R==Expected);
	end
end

end
