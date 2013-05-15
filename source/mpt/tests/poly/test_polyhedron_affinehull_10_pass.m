function test_polyhedron_affinehull_10_pass
%
% array of 2 polyhedra
%

P(1) = Polyhedron('A',randn(13,15),'b',5*ones(13,1),'Ae',[zeros(5,15); randn(4) zeros(4,11)],'be',randn(9,1));
P(2) = Polyhedron('ub',10*rand(5,1),'lb',-20*ones(5,1),'He',randn(8,6));

a =  P.affineHull;

for i=1:2
    if isempty(a{i})
        error('Should not be empty.');
    end
end

end