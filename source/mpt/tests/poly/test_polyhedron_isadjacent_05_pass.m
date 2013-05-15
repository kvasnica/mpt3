function test_polyhedron_isadjacent_05_pass
%
% simple adjacency test- P and Q in 2D and are adjacent
%
% all are adjacent
%

H =[ -0.039385    -0.011962            0
      0.25807     0.078687            0
            0           -1           10
    -0.053731    -0.010858            0
      -0.3562    -0.094458            0];
      
P = Polyhedron('H',H);

Q1 = Polyhedron('lb',[2;-10],'ub',[3, 0],'H',-P(1).H(1,:));
Q2 = Polyhedron('lb',[0;-10],'ub',[2, 0],'H',-P(1).H(1,:));

if ~P.isAdjacent(Q1) || ~P.isAdjacent(Q2) || ...
        ~Q1.isAdjacent(Q2) || ~Q1.isAdjacent(P) || ...
        ~Q2.isAdjacent(Q1) || ~Q2.isAdjacent(P)
    error('Regions are adjacent.');
end
 
  
end