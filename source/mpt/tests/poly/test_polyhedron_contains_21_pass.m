function test_polyhedron_contains_21_pass
%
% infeasible polyhedron does not contain a point
%

P = Polyhedron(randn(21,2),randn(21,1));

if any(P.contains(randn(2)))
    error('P is the same as Q.');
end


end