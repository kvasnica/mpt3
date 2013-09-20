function test_polyhedron_isneighbor_08_pass
%
%  intersection and set difference for V rep
%

P = Polyhedron([0.4831     -0.11977     -0.10502     -0.25165;
      -1.8246       2.1187     -0.59845      0.52464;
     -0.27554     -0.39938       2.8882     -0.67317;
      0.83417     -0.24896     -0.44095      0.94983;
     -0.86262     -0.56024     -0.76419       1.3002]);
Q = Polyhedron([-1.2244      -1.1371     -0.60891      0.80834;
     -0.22872      0.31196      0.92326      0.08095;
     -0.20601       -1.319       1.8512   -0.0060079;
      0.76319     -0.66938     -0.53326       1.9489;
      0.34285     -0.70068     -0.53868      0.22868;
        1.593      -1.5404       1.6965      0.13504;
       1.1722      0.22848     -0.17669      -0.7256]);

T = intersect(P,Q);
R = P\T;

% T must be adjacent to each R
for i=1:length(R)
    if ~T.isNeighbor(R(i))
        error('Regions must be adjacent.');
    end
end

end