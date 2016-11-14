function test_polyhedron_contains_08_pass
%
% He-He, lower-dimensional in 2D 
%

P = Polyhedron('He',[1 -1 0],'lb',[-3;-3],'ub',[2;2]);

S = Polyhedron('He',[1 -1 0],'lb',[-4;-4],'ub',[3;3]);

% P is obviously contained in S

if ~S.contains(P)
    error('P must contain R.')
end

end