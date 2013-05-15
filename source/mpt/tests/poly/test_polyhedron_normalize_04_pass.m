function test_polyhedron_normalize_04_pass
%
% V-polyhedron - no change
%

P = ExamplePoly.randVrep;
P.normalize;

if P.hasHRep
    error('H-rep must be empty.');
end

end
