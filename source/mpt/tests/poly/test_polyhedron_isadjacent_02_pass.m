function test_polyhedron_isadjacent_02_pass
%
% simple adjacency test- P and Q in 2D and are adjacent
%
% must return 1-1 indices


H =[ -0.039385    -0.011962            0
      0.25807     0.078687            0
            0           -1           10
    -0.053731    -0.010858            0
      -0.3562    -0.094458            0];
      
P = Polyhedron('H',H);

Q = Polyhedron('lb',[0;-10],'ub',[2, 0],'H',-P(1).H(1,:));

[ts, iP, iQ] = P.isAdjacent(Q);

if ~ts || iP~=1 || iQ~=1
   error('Regions are adjacent.');
end
   
  
end