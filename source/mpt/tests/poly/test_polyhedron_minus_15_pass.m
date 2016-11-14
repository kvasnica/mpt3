function test_polyhedron_minus_15_pass
%
% unbounded - unbounded
%

P = Polyhedron('lb',[0;0;0]);
S = Polyhedron('lb',[1;1;1]);

R = P-S;

if R.isBounded
    error('R is unbounded.');
end
if R~=P
    error('R and P are the same.');
end


end