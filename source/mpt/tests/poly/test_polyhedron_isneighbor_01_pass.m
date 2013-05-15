function test_polyhedron_isneighbor_01_pass
%
% test neighborhood of two paraller regions
%

global MPTOPTIONS

H1 = [0.039385     0.011962            0
        -1            0            0
         0           -1           10
         1            0            2];
     
     
H2 = [  -0.25807    -0.078687         0
            0           -1            8
            1            0          2.5
            0            1           -2];
        

P = Polyhedron('H',H1);
Q = Polyhedron('H',H2);
        
% distance between P, Q is 0.0022695 
dt = distance(P,Q);

[ts,iP,iQ]=isNeighbor(P,Q);

if dt.dist<MPTOPTIONS.region_tol && ~ts
    error('P and Q are neighbors with this region tolerance');
end


end