function test_polyhedron_isfulldim_02_pass
%
% isFullDim test
% 
% 

P = Polyhedron('H',[-eye(3) zeros(3,1)],'He',[1 0 0 1]);

if isFullDim(P)
    error('Given polyhedron object should not be full-dimensional.');
end
