function  test_polyhedron_project_01_pass
%
%
%

P = ExamplePoly.randHrep;
d = P.project([12;30]);

if isempty(d.dist)
    error('Wrong result.');
end

end