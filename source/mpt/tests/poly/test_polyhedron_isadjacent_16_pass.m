function test_polyhedron_isadjacent_16_pass
%
% simple adjacency test- P and Q in 2D and are adjacent
%
% wrong index set (contains -1)
%
%

H =[ -0.039385    -0.011962            0
      0.25807     0.078687            0
            0           -1           10
    -0.053731    -0.010858            0
      -0.3562    -0.094458            0];
      
P = Polyhedron('H',H);

Q = Polyhedron('lb',[2;-10],'ub',[3, 0],'H',-P(1).H(1,:));

[worked, msg] = run_in_caller('P.isAdjacent(Q,[3,-1]); ');
assert(~worked);
asserterrmsg(msg,'Input argument is a not valid index set.');

 
  
end