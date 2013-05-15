function test_polyhedron_affinemap_01_pass
%
% empty polyhedron
%

P = Polyhedron('H',randn(16,5));

if ~P.isEmptySet
    error('P must be empty.');
end

Q = P.affineMap(randn(4));

if ~Q.isEmptySet
    error('Q must be empty.');
end

end