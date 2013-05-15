function test_polyhedron_shoot_04_pass
%
% V-polyhedron
%
global MPTOPTIONS

P = ExamplePoly.randVrep('d',3);
while ~P.contains([0;0;0])
    P = ExamplePoly.randVrep('d',3);
end

r = P.shoot([0 1 -2]);

if r.exitflag~=MPTOPTIONS.OK
    error('Must be ok handle here.');
end



end