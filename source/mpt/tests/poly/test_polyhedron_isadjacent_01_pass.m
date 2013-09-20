function test_polyhedron_isadjacent_01_pass
%
% all are neighbors, but Q1 and Q2 share the same facet
%

H =[ -0.039385    -0.011962            0
      0.25807     0.078687            0
            0           -1           10
    -0.053731    -0.010858            0
      -0.3562    -0.094458            0];
      
P = Polyhedron('H',H);

Q1 = Polyhedron('lb',[2;-10],'ub',[3, 0],'H',-P(1).H(1,:));
Q2 = Polyhedron('lb',[0;-10],'ub',[2, 0],'H',-P(1).H(1,:));

if ~P.isNeighbor(Q1) || ~P.isNeighbor(Q2) || ...
        ~Q1.isNeighbor(Q2) || ~Q1.isNeighbor(P) || ...
        ~Q2.isNeighbor(Q1) || ~Q2.isNeighbor(P)
    error('All regions are neighbors.');
end

if ~Q1.isAdjacent(Q2) || ~Q2.isAdjacent(Q1)
    error('Q1 and Q1 share the same facet.');
end
  
end