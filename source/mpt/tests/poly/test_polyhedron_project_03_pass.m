function  test_polyhedron_project_03_pass
%
% polyhedron array
%

P(1) = ExamplePoly.randVrep;
P(2) = ExamplePoly.randHrep;
d = P.project([12;30]);

for i=1:2
    if isempty(d(i).dist)
        error('Wrong result.');
    end
end

end
