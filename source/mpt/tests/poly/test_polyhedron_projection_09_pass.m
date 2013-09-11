function test_polyhedron_projection_09_pass
%
% affine set + lower bound
%

P = Polyhedron('Ae',rand(2,3),'be',rand(2,1),'lb',[-1;-5;-2]);
while P.isEmptySet
    P = Polyhedron('Ae',rand(2,3),'be',rand(2,1),'lb',[-1;-5;-2]);
end

% R is just a point
R(1) = P.projection([1,2],'mplp');
R(2) = P.projection([1,2],'fourier');
R(3) = P.projection([1,2],'vrep');
R(4) = P.projection([1,2],'ifourier');

R.minHRep();
if any(R.isEmptySet)
    error('R is not empty');    
end
for i = 2:length(R)
	assert( norm(R(1).He-R(i).He,Inf)<=1e-4 );
end

end
