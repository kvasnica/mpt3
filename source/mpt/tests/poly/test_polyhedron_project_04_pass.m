function  test_polyhedron_project_04_pass
%
% polyhedron array + matrix
%

P(1) = ExamplePoly.randVrep;
P(2) = ExamplePoly.randHrep;
x = randn(2, 5);

% arrays must be rejected
[~, msg] = run_in_caller('d = P.project(x);');
asserterrmsg(msg, 'This method does not support arrays. Use the forEach() method.');

d = P.forEach(@(e) e.project(x), 'UniformOutput', false);

for i=1:2
    dist = [d{i}.dist];
    if any(isempty(dist))
        error('Wrong result.');
    end
end

end
