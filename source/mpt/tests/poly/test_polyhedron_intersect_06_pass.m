function test_polyhedron_intersect_06_pass
%
% no intersection
%

Pn = ExamplePoly.randZono('d',7);
P = Pn - 7*ones(7,1);
S = Pn + 7*ones(7,1);

R = P.intersect(S);

if ~isEmptySet(R)
    error('Must be empty because the sets are far away.');
end


end