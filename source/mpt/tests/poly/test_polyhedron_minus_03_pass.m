function test_polyhedron_minus_03_pass
%
% H-H polyhedra
%


P = ExamplePoly.randHrep('d',3);
S = 0.1*P;

R = P-S;

if ~P.contains(R) || ~R.contains(S)
    error('P must contain R and R must contain S.');
end

end