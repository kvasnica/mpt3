function test_polyhedron_eq_02_pass
%
% empty array - non-empty
% 

P = Polyhedron;
P(1)=[];
Q = ExamplePoly.randHrep;

ts1 = (P==Q);

if ts1
    error('The result should be false.');
end

ts2 = (Q==P);

if ts2
    error('The result should be false.');
end

end
