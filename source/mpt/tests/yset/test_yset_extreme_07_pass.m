function test_yset_extreme_07_pass
%
% the point lies inside the set, test the boundary
%

x = sdpvar(2,1);

A1 =[    0.081547      -1.2313
     -0.47983      0.63823
       1.7189      0.32097
      -0.7746       1.0576
     -0.28719      -1.6943
     -0.87622     -0.35498];
A2 = [-0.53144     -0.36517
      -1.8143      -1.2937
      0.58853      0.96656
      0.20858     0.92154
     -0.88152      -1.6804
     0.0071       -2.9;
       3.7        -1.34];
b1 = 5*[0.5; 0.62; 0.78; 0.12; 0.67; 3.5];
b2 = [0.4; 0.78; 0.98; 0.52; 0.5; 0.71; 8.3];

F = [x'*x <= 1] + [A1*x<=b1] + [A2*x<=b2];

S = YSet(x,F);

% z is inside the set
z = [0.2; 0.2];
if ~S.contains(z)
    error('This point must lie inside S, otherwise the test is not valid.');
end

s = S.extreme(z);
% the extreme point must satisfy all three sets of constraints
assert(s.x'*s.x<=1);
assert(max(A1*s.x-b1)<1e-7);
assert(max(A2*s.x-b2)<1e-7);

% the computed point must lie on the boundary of the set
if ~S.contains(s.x)
    error('This point lies on the boundary of this set.');
end
w = s.x;
% move the point outside of the set a tolerance bit
w(1) = s.x(1)*1.001;  
if S.contains(w)
    error('This point must be outside of the set.');
end


end
