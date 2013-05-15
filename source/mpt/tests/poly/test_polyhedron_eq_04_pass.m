function test_polyhedron_eq_04_pass
%
% non-empty polyhedron-non-empty polyhedron
% 

P = ExamplePoly.randHrep;
Q = ExamplePoly.randVrep;

ts = (P==Q);

if ts
    error('The result should be false.');
end

end
