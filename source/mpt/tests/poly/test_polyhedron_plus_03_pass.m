function test_polyhedron_plus_03_pass
%
% H-H polyhedra
%


P = ExamplePoly.randHrep('d',3);
S = ExamplePoly.randHrep('d',3);


R = P+S;

if ~R.contains(P) || ~R.contains(S)
    error('R must contain both polyhedra.');
end

end