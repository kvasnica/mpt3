function test_polyhedron_shoot_01_pass
%
% empty polyhedron
%
global MPTOPTIONS

P=Polyhedron;
r = P.shoot([]);

if r.exitflag~=MPTOPTIONS.ERROR
    error('Must be error handle here.');
end



end