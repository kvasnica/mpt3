function test_polyhedron_minus_06_pass
%
% array of V-V polyhedra
%

P(1) = ExamplePoly.randVrep('d',3);
P(2) = ExamplePoly.randVrep('d',3);

S = ExamplePoly.randVrep('d',3);
Sn = intersect(Polyhedron('lb',[0;0;0],'ub',[0.1;0.04; 0]),S);
Sn.computeVRep();
S = Polyhedron('V',Sn.V,'R',Sn.R);


R = P-S;

for i=1:2
    if ~P.contains(R(i))
        error('P must contain both R.');
    end
end
end
