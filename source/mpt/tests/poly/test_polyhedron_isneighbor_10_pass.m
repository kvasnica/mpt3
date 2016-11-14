function test_polyhedron_isneighbor_10_pass
%
%  full-dim and affine set
%

P = Polyhedron('H',[11.662            1       8.8301
                    -2.3259           -1      -2.0099
                    1       3.3546       4.3638]);

% last face of P                
Q1 = Polyhedron('He',[1       3.3546       4.3638]);

[ts1, ~, iQ] = P.isNeighbor(Q1);
if ~ts1
    error('Regions must be neighbors.')
end
if ~isempty(iQ)
    error('The index for Q should be empty because it points to equality constraint.');
end

[ts2, iQ] = Q1.isNeighbor(P);
if ~ts2
    error('Regions must be neighbors.')
end
if ~isempty(iQ)
    error('The index for Q should be empty because it points to equality constraint.');
end

% reverted last face of P                
Q2 = Polyhedron('He',-[1       3.3546       4.3638]);

if ~P.isNeighbor(Q2)
    error('Regions must be neighbors.')
end

if ~Q2.isNeighbor(P)
    error('Regions must be neighbors.')
end


end