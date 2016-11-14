function test_polyhedron_isempty_14_pass
%
% isempty test
% 
% 
H=[
         0.35619841331004         0.094457718863219     -1.99840144432528e-15
       -0.0556247434624066        0.0301836516131431     -4.56680027127732e-09
         0.218871575749019         0.066880322338989     -3.97924626582835e-09
       -0.0463373390151258       -0.0135075938316201      5.96046447753906e-08];
V = [0 0]; % non-empty vertices = set is NOT empty
P = Polyhedron('V',V,'H',H);
assert(~P.isEmptySet);

end
