function test_polyhedron_affinehull_03_pass
%
% He-polyhedron
%

He= [  4.3192e-05      0.73096     -0.37747       1.4435
     -0.31786      0.57786     -0.29589     -0.35097 ];
P = Polyhedron('He',He,'lb',-5*ones(3,1),'ub',5*ones(3,1));


a = P.affineHull;

Q = Polyhedron('H',P.H,'He',a);
an = Q.affineHull;

if norm(a(:)-an(:),Inf)>1e-4
    error('Affine hulls should be the same.');
end

end