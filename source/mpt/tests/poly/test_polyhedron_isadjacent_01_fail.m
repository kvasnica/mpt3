function test_polyhedron_isadjacent_01_fail
%
% simple adjacency test- P and Q in 2D and are adjacent
%
% facet indices provided, but out of range
%
%

H =[ -0.039385    -0.011962            0
      0.25807     0.078687            0
            0           -1           10
    -0.053731    -0.010858            0
      -0.3562    -0.094458            0];
      
P = Polyhedron('H',H);

Q = Polyhedron('lb',[0;-10],'ub',[2, 0],'H',-P(1).H(1,:));

[ts, iP, iQ] = P.isAdjacent(Q,[1,4],2);

   
  
end