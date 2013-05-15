function test_polyhedron_eq_05_pass
%
% the same polyhedron in higher dims
% 

P = ExamplePoly.randHrep('d',7);
Q = Polyhedron(P);

ts = (P==Q);

if ~ts
    error('The result should be true.');
end

Pn = ExamplePoly.randVrep('d',18);
Qn = Polyhedron(Pn);

tsn = (Pn==Qn);

if ~tsn
    error('The result should be true.');
end


end
