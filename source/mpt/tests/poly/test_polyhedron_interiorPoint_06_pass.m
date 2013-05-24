function test_polyhedron_interiorPoint_06_pass
%
% affine set, ray
%

P(1) = Polyhedron('He',[1 -2 0 0.1; -2.1 -3 0 -5]);
P(2) = Polyhedron('R',[0 1]);

res = P.interiorPoint;

for i=1:2
    if ~P(i).contains(res(i).x)
        error('The point must lie inside the set.');
    end
end

end
