function test_polyhedron_isempty_18_pass
%
% affine set
%

P = Polyhedron('He',[1 -2 0 0.1; -2.1 -3 0 -5]);

if P.isEmptySet
    error('Affine set is not empty.');
end

end