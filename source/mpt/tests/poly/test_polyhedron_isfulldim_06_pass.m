function test_polyhedron_isfulldim_06_pass
%
% isFullDim test
% 
% 

Q = Polyhedron('lb',-ones(3,1),'he',[0 0.5 0 5.3]);
Q2 = Q*Q;
if isFullDim(Q2)
    error('Given polyhedron object should not be full-dimensional.');
end

end
