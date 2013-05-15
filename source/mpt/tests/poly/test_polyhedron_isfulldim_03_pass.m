function test_polyhedron_isfulldim_03_pass
%
% isFullDim test
% 
% 

Q = Polyhedron;
P = 2*Q;
if any(isFullDim([P;Q]))
    error('Given polyhedron object should not be full-dimensional.');
end
