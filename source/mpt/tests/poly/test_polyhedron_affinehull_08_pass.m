function test_polyhedron_affinehull_08_pass
%
% lower-dimensional polyhedron in 13D
%


He = [randn(7,13), 10*rand(7,1)];

P = Polyhedron('He',He,'lb',-10*ones(13,1),'ub',10*ones(13,1));

a = P.affineHull;

% revert and put back again
Pn = Polyhedron('lb',-10*ones(13,1),'ub',10*ones(13,1),'He',flipud(He));

an = Pn.affineHull;

P1 = Polyhedron('H',a);
P2 = Polyhedron('H',an);

if P1~=P2
    error('Affine hulls do not fit.');
end

end