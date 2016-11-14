function  test_polyhedron_project_03_pass
%
% polyhedron array
%

P(1) = ExamplePoly.randVrep;
P(2) = ExamplePoly.randHrep;

% arrays are rejected because size of output from Polyhedron/project
% depends on cardinality of "y"
[worked, msg] = run_in_caller('d = P.project([12;30]);');
assert(~worked);
asserterrmsg(msg, 'This method does not support arrays. Use the forEach() method.');

% here we have a single point, so output from forEach is uniform
d = P.forEach(@(elem) elem.project([12;30]));

for i=1:2
    if isempty(d(i).dist)
        error('Wrong result.');
    end
end

end
