function test_polyhedron_separate_01_pass
%
% two distinct polyhedra
%
P = ExamplePoly.randHrep;
while ~P.isBounded
    P = ExamplePoly.randHrep;
end
Q = P+[10;10];

h = P.separate(Q);

if isempty(h)
    error('There must be separating hyperplane.');
end


end