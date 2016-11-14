function test_polyhedron_volume_04_pass
%
% low-dim, unbounded array polyhedron
% 

P(1) = 10*ExamplePoly.randHrep('d',5,'ne',2);

while ~P(1).isBounded
    P(1) = 10*ExamplePoly.randHrep('d',5,'ne',2);
end
P(2) = 10*ExamplePoly.randVrep('d',5,'nr',2);

v = P.volume;

if v(1)>1e-4 || ~isinf(v(2))
    error('Must be 0 and Inf here.');
end

end
