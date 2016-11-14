function test_polyhedron_eq_06_pass
%
% two polyhedra - one polyhedron
% 

P(1) = ExamplePoly.randHrep('d',3);
P(2) = ExamplePoly.randVrep('d',3);
Q = Polyhedron(P(2));

ts = (P==Q);

if ts
    error('The result should be false.');
end

end
