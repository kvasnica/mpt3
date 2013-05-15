function test_polyhedron_homogenize_02_pass
%
% not feasible polyhedron 
%

% not feasible
P = Polyhedron('H',[-0.36215     -0.44313       1.1462      0.51896
       1.6953      0.86995      -2.1671     -0.41793
      -1.7092       1.1406      -0.3226      -1.4616
      0.31489     -0.62172      -1.0504      -1.2978]);
if ~P.isEmptySet
    error('P must be empty.');
end

R = P.homogenize;

% lifting not-feasible polyhedron we get feasible one
if R.isEmptySet
    error('Must not be empty polyhedron.');
end

end