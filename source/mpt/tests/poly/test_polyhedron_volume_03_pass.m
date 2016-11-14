function test_polyhedron_volume_03_pass
%
% low-dim polyhedron
% 

P = 10*ExamplePoly.randHrep('d',5,'ne',2);
while ~P.isBounded
    P = 10*ExamplePoly.randHrep('d',5,'ne',2);
end

v = P.volume;

if v>1e-4
    error('Must be 0 here.');
end

end
