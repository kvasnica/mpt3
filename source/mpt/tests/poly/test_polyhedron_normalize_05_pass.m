function test_polyhedron_normalize_05_pass
%
% V-polyhedron array - no change
%

P(1) = ExamplePoly.randVrep;
P(2) = 1023*Polyhedron(80*randn(76,6));
P.normalize;

for i=1:2
    if P(i).hasHRep
        error('H-rep must be empty.');
    end
end

end
