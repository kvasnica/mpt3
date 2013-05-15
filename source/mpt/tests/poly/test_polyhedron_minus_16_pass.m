function test_polyhedron_minus_16_pass
%
% unbounded - affine set (point)
%

P = Polyhedron('R',[0 1;0.1 -2]);
S = Polyhedron('Ae',[1.4952,-2.1251;-0.32494, 1.2727],'be',[1;2]);

R = P-S;

if R.isBounded
    error('R is unbounded.');
end
if R~=P
    error('P and S are the same.');
end


end