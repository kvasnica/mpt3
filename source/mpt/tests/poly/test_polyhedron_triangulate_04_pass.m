function test_polyhedron_triangulate_04_pass
%
% bounding box
%

P(1) = ExamplePoly.randHrep('d',5);
P(2) = ExamplePoly.randHrep('d',4);
P(3) = 10*ExamplePoly.randVrep('d',3);

while any(~P.isBounded)
    P(1) = ExamplePoly.randHrep('d',5);
    P(2) = ExamplePoly.randHrep('d',4);
    P(3) = 10*ExamplePoly.randVrep('d',3);
end

B = P.outerApprox;

% arrays must be rejected
[~, msg] = run_in_caller('T = triangulate(B);');
asserterrmsg(msg, 'This method does not support arrays. Use the forEach() method.');

% forEach must require UniformOutput=true
[~, msg] = run_in_caller('T = B.forEach(@(e) e.triangulate())');
asserterrmsg(msg, 'Non-scalar in Uniform output, at index 1, output 1.');

% correct syntax
T = B.forEach(@(e) e.triangulate, 'UniformOutput', false);

for i=1:3
for j=1:numel(T{i})
    if any(~B(i).contains(T{i}(j)))
        error('Must be inside P.');
    end
end

end

end
