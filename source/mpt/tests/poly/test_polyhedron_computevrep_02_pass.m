function test_polyhedron_computevrep_02_pass
% improved vertex enumeration by shifting to the origin (issue #132)

% simplex with vertices [10; 10], [10; 11], [11; 10] which does not contain
% the origin in its interior. this test verifies that we correctly shift
% the polytope to the origin and then the vertices back
H = [0 -1 -10;0.707106781186547 0.707106781186548 14.8492424049175;-1 -2.92887086866172e-15 -10];
P = Polyhedron('H', H);
Vexp = sortrows([10 10; 10 11; 11 10]);
assert(norm(sortrows(P.V)-Vexp, Inf)<=1e-6);

end
