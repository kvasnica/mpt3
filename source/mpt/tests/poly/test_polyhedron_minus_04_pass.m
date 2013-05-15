function test_polyhedron_minus_04_pass
%
% He-H polyhedra
%


He = [ -0.24578      0.90193      0.35513            0];
P = Polyhedron('A',randn(8,3),'b',2*rand(8,1),'He',He);
S = Polyhedron('lb',[0;0;0],'ub',[0.1;0.2;0],'He',He);

R = P-S;

if ~P.contains(R)
    error('R must contain both polyhedra.');
end

end