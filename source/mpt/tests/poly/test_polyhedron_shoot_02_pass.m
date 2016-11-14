function test_polyhedron_shoot_02_pass
%
% infeasible polyhedron
%

global MPTOPTIONS

P=Polyhedron(randn(186,24),randn(186,1));
r = P.shoot(randn(1,24));

if r.exitflag==MPTOPTIONS.OK || r.exitflag==MPTOPTIONS.UNBOUNDED
    error('Must be error/infeasible handle here.');
end



end