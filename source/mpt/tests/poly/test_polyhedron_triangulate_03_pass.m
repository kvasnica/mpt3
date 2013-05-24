function test_polyhedron_triangulate_03_pass
%
% [H-V]-rep, 3D
%

P(1) = 10*ExamplePoly.randHrep('d',3);
P(2) = 10*ExamplePoly.randVrep('d',3);

while any(~P.isBounded)
    P(1) = 10*ExamplePoly.randHrep('d',3);
    P(2) = 10*ExamplePoly.randVrep('d',3);
end

% arrays must be rejected
[~, msg] = run_in_caller('T = triangulate(P);');
asserterrmsg(msg, 'This method does not support arrays. Use the forEach() method.');

% forEach must require UniformOutput=true
[~, msg] = run_in_caller('T = P.forEach(@(e) e.triangulate())');
asserterrmsg(msg, 'Non-scalar in Uniform output, at index 1, output 1.');

% correct syntax
T = P.forEach(@(e) e.triangulate, 'UniformOutput', false);

for i=1:2
for j=1:numel(T{i})
    if any(~P(i).contains(T{i}(j)))
        error('Must be inside P.');
    end
end

end
