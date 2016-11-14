function test_polyhedron_minus_07_pass
%
% array of [R,V]-V polyhedra
%

P(1) = Polyhedron('R',[0 1 -1;0.1 -0.2 1]);
P(2) = ExamplePoly.randVrep('d',3);

Sn = Polyhedron('lb',[0;0;0],'ub',[0.1;0.04; 0]);
Sn.computeVRep();
S = Polyhedron('V',Sn.V,'R',P(1).R);

R = P-S;

if any(~R.isEmptySet)
    error('S is unbounded, thus the pontryagin difference is empty.');
end

end
