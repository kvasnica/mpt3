function test_polyhedron_isadjacent_11_pass
%
%  full-dim and affine set
%

P = Polyhedron('H',[11.662            1       8.8301
                    -2.3259           -1      -2.0099
                    1       3.3546       4.3638]);

% last face of P                
Q1 = Polyhedron('He',[1       3.3546       4.3638]);


if ~P.isAdjacent(Q1)
    error('Regions must be adjacent.')
end

if ~Q1.isAdjacent(P)
    error('Regions must be adjacent.')
end


% reverted last face of P                
Q2 = Polyhedron('He',-[1       3.3546       4.3638]);

if ~P.isAdjacent(Q2)
    error('Regions must be adjacent.')
end

if ~Q2.isAdjacent(P)
    error('Regions must be adjacent.')
end


end