function test_polyhedron_minus_14_pass
%
% unbounded - vector
%

P = Polyhedron('lb',[0;0;0]);
x = [1;1;1];

R = P-x;

if any(~R.contains(-x))
    error('R must contain x.');
end
if R.isBounded
    error('R is unbounded.');
end


end