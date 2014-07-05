function test_polyhedron_separate_13_pass
% separation of a polytope and a cone

% we test all combinations of representations
PV = Polyhedron('V', [1 1; 1 2; 2 1; 2 2]);
PH = Polyhedron('lb', [1; 1], 'ub', [2; 2]);
CpV = Polyhedron('R', eye(2));
CpH = Polyhedron('lb', [0; 0]');
CnV = Polyhedron('R', -eye(2));
CnH = Polyhedron('ub', [0; 0]);
P = [PV, PH];
Cp = [CpV, CpH];
Cn = [CnV, CnH];

% the positive orthant contains P, hence no separation
expected = [];
for i = 1:length(P)
	for j = 1:length(Cp)
		sep = P(i).separate(Cp(j));
		assert(isequal(sep, expected));
		sep = Cp(j).separate(P(i));
		assert(isequal(sep, expected));
	end
end

% the negative orthant does not contain P, hence separation must exist
expected = [1 1 1];
for i = 1:length(P)
	for j = 1:length(Cp)
		sep = P(i).separate(Cn(j));
		assert(norm(sep-expected) < 1e-8);
		sep = Cn(j).separate(P(i));
		assert(norm(abs(sep)-expected) < 1e-8);
	end
end

end
