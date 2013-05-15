function test_polyhedron_eq_08_pass
%
% unbounded polyhedra 
% 

for i=1:3
    P(i) = ExamplePoly.randVrep('d',3,'nr',1);
end


Q = Polyhedron(P);

ts = (P==Q);

if ~ts
    error('The result should be true.');
end

tsn = (P(1)==Q);

if tsn
    error('The result should be false.');
end

end
