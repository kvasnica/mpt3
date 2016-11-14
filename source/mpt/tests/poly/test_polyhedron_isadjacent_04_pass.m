function test_polyhedron_isadjacent_04_pass
%
%  full-dim and low-dim (which is a face)
%

P = Polyhedron('H',[11.662            1       8.8301;
                    -2.3259           -1      -2.0099;
                    1       3.3546       4.3638]);

% last face of P                
Q1 = Polyhedron('H',[11.662            1       8.8301;
                    -2.3259           -1      -2.0099],...
               'He',[1       3.3546       4.3638]);


if ~P.isAdjacent(Q1)
    error('Regions must be adjacent.')
end
if ~Q1.isAdjacent(P)
    error('Regions must be adjacent.')
end

% revert last face of P                
Q2 = Polyhedron('H',[11.662            1       8.8301;
                    -2.3259           -1      -2.0099],...
               'He',-[1       3.3546       4.3638]);


if ~P.isAdjacent(Q2)
    error('Regions must be adjacent.')
end
if ~Q2.isAdjacent(P)
    error('Regions must be adjacent.')
end
           

end