function test_polyhedron_isadjacent_05_pass
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

[worked, msg] = run_in_caller('P.isAdjacent(Q) ');
assert(~worked);
asserterrmsg(msg,'P and Q must have the length of 1.');
 
  
end