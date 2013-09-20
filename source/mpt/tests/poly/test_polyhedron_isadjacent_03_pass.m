function test_polyhedron_isadjacent_08_pass
%
%  there is an empty region between P and Q -> not adjacent
%

H1 = [0.039385     0.011962            0
           -1            0            0
            0           -1           10
            1            0            2];

H2 = [ -0.25807    -0.078687            0
            0           -1            8
            1            0          2.5
            0            1           -2];        
        
P = Polyhedron('H',H1);
Q = Polyhedron('H',H2);
        
if P.isAdjacent(Q) || Q.isAdjacent(P)
    error('Regions are not adjacent, there is empty but feasible region between.');
end

end