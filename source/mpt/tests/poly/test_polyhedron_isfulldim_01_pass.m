function test_polyhedron_isfulldim_01_pass
%
% isFullDim test
% 
% 

% empty polyhedron is not fulldim
if isFullDim(Polyhedron)
    error('Given polyhedron object should not be full-dimensional.');
end

end
