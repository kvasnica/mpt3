function test_polyhedron_extreme_07_pass
%
% random array of H-V polyhedra in 24 D
%


P(1) = ExamplePoly.randHrep('d',24);
P(2) = ExamplePoly.randVrep('d',24);

solV = P.forEach(@(x) x.V, 'UniformOutput', false);
solR = P.forEach(@(x) x.R, 'UniformOutput', false);

% all vertices must lie inside both sets
if P(1)~=Polyhedron('V',solV{1},'R',solR{1});
    error('Wrong P(1)');
end

if P(2)~=Polyhedron('V',solV{2},'R',solR{2});
    error('Wrong P(2)');
end

end
