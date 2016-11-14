function  test_polyhedron_project_02_pass
%
% V-polyhedron
%

P = ExamplePoly.randVrep;
d = P.project([12;30]);

if isempty(d.dist)
    error('Wrong result.');
end

end