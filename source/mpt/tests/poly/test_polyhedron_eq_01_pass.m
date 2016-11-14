function test_polyhedron_eq_01_pass
%
% empty array - empty array
% 

P = Polyhedron;
P(1)=[];
Q = ExamplePoly.randHrep;
Q(1) = [];

ts = (P==Q);

if ~ts
    error('The result should be true "empty array = empty array".');
end

end
