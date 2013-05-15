function test_polyhedron_isadjacent_06_pass
%
%  empty polyhedron
%
%

H =[ -0.039385    -0.011962            0
      0.25807     0.078687            0
            0           -1           10
    -0.053731    -0.010858            0
      -0.3562    -0.094458            0];
      
P = Polyhedron('H',H);

% Q should be infeasible
Q = Polyhedron('H',randn(40,3));

ts1 = P.isAdjacent(Q);
ts2 = Q.isAdjacent(P);
 
  if ts1 || ts2
      error('Empty regions are not adjacent.');
  end

end