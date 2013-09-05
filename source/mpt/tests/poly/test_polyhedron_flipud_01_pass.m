function test_polyhedron_flipud_01_pass
% tests Polyhedron/flipud and flipur (issue #81)

P = [];
for d = 1:3
	P = [P, Polyhedron.unitBox(d)];
end

F = flipud(P);
for d = 1:3
	assert(F(d).Dim==4-d);
	% the original array must stay the same
	assert(P(d).Dim==d);
end

% fliplr() should do the same
F = fliplr(P);
for d = 1:3
	assert(F(d).Dim==4-d);
	% the original array must stay the same
	assert(P(d).Dim==d);
end

end
