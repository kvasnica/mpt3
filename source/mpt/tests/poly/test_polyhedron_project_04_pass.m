function  test_polyhedron_project_04_pass
%
% polyhedron array + matrix
%

P(1) = ExamplePoly.randVrep;
P(2) = ExamplePoly.randHrep;
d = P.project(randn(5,2));

for i=1:2
    dist = [d{i}.dist];
    if any(isempty(dist))
        error('Wrong result.');
    end
end

end