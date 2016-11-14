function test_polyhedron_minhrep_01_pass
% redundant zero rows must be removed

% it appears that zero rows are missed randomly, therefore we repeat the
% test couple of times

for i = 1:10
	% second row is redundant
	H = [1 0 0; 0 0 1; 2 3 2];
	P = Polyhedron(H(:, 1:end-1), H(:, end));
	P.minHRep();
	assert(isequal(P.H, H([1 3], :)));
	
	% second row is still redundant
	H = [1 0 0; 0 0 1; 2 3 2];
	P = Polyhedron(H(:, 1:end-1), H(:, end));
	P.minHRep();
	assert(isequal(P.H, H([1 3], :)));
end

end
