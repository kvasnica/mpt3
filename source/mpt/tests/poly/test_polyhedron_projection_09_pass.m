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

R.minHRep();
if any(R.isEmptySet)
    error('R is not empty');    
end
if norm(R(1).He-R(2).He,Inf)>1e-4 || norm(R(1).He-R(3).He,Inf)>1e-4 || norm(R(2).He-R(3).He,Inf)>1e-4
   error('R must be the same for all methods.'); 
end

end
