function test_polyhedron_separate_02_pass
%
% infeasible polyhedron
%
P = ExamplePoly.randHrep;
Q = Polyhedron(randn(17,2),randn(17,1));

h = P.separate(Q);

if ~isempty(h)
    error('There is no separating hyperplane.');
end

end