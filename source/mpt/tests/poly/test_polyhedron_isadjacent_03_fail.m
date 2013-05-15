function test_polyhedron_isadjacent_03_fail
%
%  arrays not allowed
%
%

H =[ -0.039385    -0.011962            0
      0.25807     0.078687            0
            0           -1           10
    -0.053731    -0.010858            0
      -0.3562    -0.094458            0];
      
P = Polyhedron('H',H);

Q = [Polyhedron, Polyhedron('lb',[0;-10],'ub',[2, 0],'H',-P(1).H(1,:))];

P.isAdjacent(Q)
 
  
end