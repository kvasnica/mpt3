function test_polyhedron_45_pass
% tests nornalization of Inf rows

% rows with a'*x<=+/-Inf should be replaced by 0'*x<=+/-1

H = [0 0 0; ...
	0 0 Inf; ...
	0 0 2; ...
	0 0 -2; ...
	0 0 -Inf; ...
	1 1 0; ...
	1 1 Inf; ...
	1 1 -Inf ];
Hgood = [0 0 0; ...
	0 0 1; ...
	0 0 2; ...
	0 0 -2; ...
	0 0 -1; ...
	1 1 0; ...
	0 0 1; ...
	0 0 -1];

% faster constructor
P = Polyhedron(H(:, 1:end-1), H(:, end));
assert(isequal(P.H, Hgood));

% full constructor
P = Polyhedron('A', H(:, 1:end-1), 'b', H(:, end));
assert(isequal(P.H, Hgood));

end
