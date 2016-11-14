function test_polyhedron_volume_05_pass
%
% [H-V]-array polyhedron
% 

P(1) = 10*ExamplePoly.randHrep('d',5);
P(2) = 10*ExamplePoly.randVrep('d',5);

while any(~P.isBounded)
    P(1) = 10*ExamplePoly.randHrep('d',5);
    P(2) = 10*ExamplePoly.randVrep('d',5);    
end

v = P.volume;

if any(v<1e-3)
    error('Should be some values here.');
end

end
