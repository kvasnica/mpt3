function test_polyhedron_isneighbor_02_pass
%
% test neighborhood for two regions that share one point but are disjoint
% with a small triangular region between them
%

global MPTOPTIONS

H1 = [    0.039385     0.011962            0
     -0.30406    -0.091242            0
            0           -1           10];
     
     
H2 = [  -0.25807    -0.078687            0
      0.21887      0.06688            0
            0           -1           10];
        

P = Polyhedron('H',H1);
Q = Polyhedron('H',H2);

% maximum distance
dist=norm([3.037196902374;-10]-[3.0556951615114;-10]);

[ts,iP,iQ]=isNeighbor(P,Q);

if dist<MPTOPTIONS.region_tol && ~ts
    error('P and Q are close. The neighborhood depends on the tolerance.');
end


end