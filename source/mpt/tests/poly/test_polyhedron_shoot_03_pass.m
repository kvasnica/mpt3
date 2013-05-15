function test_polyhedron_shoot_03_pass
%
% H-polyhedron
%
global MPTOPTIONS

P = ExamplePoly.randHrep('d',12);
r = P.shoot(randn(1,12));

if r.exitflag~=MPTOPTIONS.OK
    error('Must be ok handle here.');
end



end