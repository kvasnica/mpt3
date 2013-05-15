function test_polyhedron_eq_09_pass
%
% low-dimensional polyhedra 
% 

for i=1:5
    P(i) = ExamplePoly.randHrep('d',3,'ne',1);
end


Q = Polyhedron(P);

ts = (P==Q);

if ~ts
    error('The result should be true.');
end

tsn = (P(1:3)==Q([1,4]));

if tsn
    error('The result should be false.');
end

end
