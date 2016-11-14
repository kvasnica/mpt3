function test_polyhedron_intersect_03_pass
%
% (He-H)-H polyhedra
%

P(1) = ExamplePoly.randHrep('d',5);
P(2) = ExamplePoly.randHrep('d',5,'ne',2);

% S is a box
S = Polyhedron('lb',-5*ones(5,1),'ub',5*ones(5,1));

R = P.intersect(S);

if any(isEmptySet(R))
    error('Must not be empty.');
end


end