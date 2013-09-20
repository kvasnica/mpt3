function test_polyhedron_isneighbor_07_pass
%
%  full-dim and low-dim polyhedron
%

V = [ 0.39347      0.71001       -0.447
       2.3374     -0.12299     -0.51271
     -0.11254      0.89459      -1.0449
       2.1187      0.37883         1.09
      -1.3253     -0.86585      -1.5705];    
P = Polyhedron(V);

% must be neighbors because He is a facet of P
Q = Polyhedron('He',[1.88497280188774, 4.01529144269429, -1, 4.42480473259544],'lb',[-10;-5;-1],'ub',[2; 2;1]);

ts1 = P.isNeighbor(Q);
ts2 = Q.isNeighbor(P);
 
if ~ts1 || ~ts2
      error('Regions must be neighbors.');
end

end