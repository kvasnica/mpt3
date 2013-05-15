function test_polyhedron_affinehull_01_pass
%
% H-polyhedron
%

% no equalities

P = Polyhedron('H',[ -0.43256       1.1909     -0.18671      0.11393
      -1.6656       1.1892      0.72579       1.0668
      0.12533    -0.037633     -0.58832     0.059281
      0.28768      0.32729       2.1832    -0.095648
      -1.1465      0.17464      -0.1364     -0.83235]);

if ~isempty(P.affineHull)
    error('Output should be empty.');
end
  
end