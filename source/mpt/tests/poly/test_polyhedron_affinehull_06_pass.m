function test_polyhedron_affinehull_06_pass
%
% V-polyhedron
%


V = [0 0;
    1 0;
    2 0];
R = [0.5 0.5;
    1 0.7;
    -1 0.3;
    -2 0.6];

P = Polyhedron('V',V,'R',R);

a =  P.affineHull;

if ~isempty(a)
    error('Affine hull should be empty.');
end

end