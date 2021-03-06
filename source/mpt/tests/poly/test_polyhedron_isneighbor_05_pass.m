function test_polyhedron_isneighbor_05_pass
%
% simple adjacency test- P and Q in 2D and are adjacent
%
% facet indices provided
%
%

H =[ -0.039385    -0.011962            0
      0.25807     0.078687            0
            0           -1           10
    -0.053731    -0.010858            0
      -0.3562    -0.094458            0];
      
P = Polyhedron('H',H);

Q = Polyhedron('lb',[2;-10],'ub',[3, 0],'H',-P(1).H(1,:));

[ts, iP, iQ] = P.isNeighbor(Q,[3,1]);

if ~ts
   error('Regions are adjacent.');
end
   
  
end