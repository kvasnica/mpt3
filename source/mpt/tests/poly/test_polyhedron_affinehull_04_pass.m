function test_polyhedron_affinehull_04_pass
%
% He-polyhedron
%

He= [ 0.21204     -0.63547      -1.1878     -0.94715      -1.1283
      0.23788     -0.55957      -2.2023     -0.37443      -1.3493
      -1.0078      0.44365      0.98634      -1.1859      -0.2611
     -0.74204      -0.9499     -0.51864      -1.0559      0.95347
       1.0823      0.78118      0.32737       1.4725      0.12864
      -0.1315      0.56896      0.23406     0.055744      0.65647
      0.38988     -0.82171     0.021466      -1.2173      -1.1678
     0.087987     -0.26561      -1.0039    -0.041227     -0.46061 ];
P = Polyhedron('He',He);

% P must be empty
if ~P.isEmptySet
    error('P is empty.');
end

a =  P.affineHull;

if norm(a-He(1:5,:),Inf)>1e-4
    error('First 5 rows should remain the same.');
end

end