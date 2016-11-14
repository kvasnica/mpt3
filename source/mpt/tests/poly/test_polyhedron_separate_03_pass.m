function test_polyhedron_separate_03_pass
%
% two intersecting polyhedra
%
P = ExamplePoly.randHrep;
Q = ExamplePoly.randVrep;

h = P.separate(Q);

if ~isempty(h)
    error('There is no separating hyperplane.');
end


end