function test_polyhedron_intersect_04_pass
%
% (He-H)-V polyhedra
%

P(1) = ExamplePoly.randHrep('d',5);
P(2) = ExamplePoly.randHrep('d',5,'ne',2);

% S is a box
S = Polyhedron('lb',-5*ones(5,1),'ub',5*ones(5,1));
S.computeVRep();
Sn = Polyhedron('V',S.V,'R',S.R);

R = P.intersect(Sn);

if any(isEmptySet(R))
    error('Must not be empty.');
end


end
