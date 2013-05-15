function test_polyhedron_projection_08_pass
%
% cone
%

P = Polyhedron('R',[0 0 1]);

% just a point
R(1) = P.projection([1,2],'mplp');
R(2) = P.projection([1,2],'fourier');
R(3) = P.projection([1,2],'vrep');

if any(R.isEmptySet)
    error('R is not empty');
end
xc = R.interiorPoint;
for i=1:3
   if norm(xc{i}.x)>1e-4
       error('The point is the origin only.');
   end
end

end