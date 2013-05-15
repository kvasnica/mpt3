function test_polyhedron_mtimes_05_pass
%
% [He,V]-V polyhedra in different dimensions
%

P(1) = Polyhedron('Ae',randn(5,8),'be',zeros(5,1));
P(2) = 45*Polyhedron('V',randn(4,8),'R',[0 0 1 0.1 -1 1 0 0]);
Q = Polyhedron('H',randn(3,5));

R = P*Q;

for i=1:2
    if R(i).isEmptySet
        error('R is not empty.');
    end
    if R(i).Dim~=12
        error('Wrong dimension of the new set.');
    end
end

end
