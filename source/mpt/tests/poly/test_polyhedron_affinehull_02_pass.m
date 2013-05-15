function test_polyhedron_affinehull_02_pass
%
% He-polyhedron
%

H = [ -0.43256       1.1909     -0.18671      0.11393
      -1.6656       1.1892      0.72579       1.0668
      0.12533    -0.037633     -0.58832     0.059281
      -1.1465      0.17464      -0.1364     -0.83235];
He = [ 0.29441      0.71432     -0.69178        1.254
      -1.3362       1.6236        0.858      -1.5937];
  
P = Polyhedron('H',H,'He',He);

a =  P.affineHull;

if norm(a(:)-He(:),Inf)>1e-4
    error('Affine hull is the same as input matrix.');
end
  
end