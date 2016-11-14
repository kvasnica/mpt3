function test_polyhedron_contains_09_pass
%
% He-He, lower-dimensional in 3D 
%

P = Polyhedron('He',[0.5 -1 0 0.4; -2 3 0.4 -0.1],'lb',[-3;-3;-3],'ub',[2;2;2]);

S = Polyhedron('He',[0.5 -1 0 0.4],'lb',[-4;-4;-4],'ub',[3;3;4]);

% P is obviously contained in S
if ~S.contains(P)
    error('S must contain P.')
end

if P.contains(S)
    error('Opposite containment does not hold.');
end

end