function test_mpt_mpsol2pu_01_pass
% propagate sol.overlaps to PolyUnion.Internal.Overlaps

sdpvar x t
sol = solvemp([0<=t<=1,1<=x<=2],t*x,[],t);

pu = mpt_mpsol2pu(sol);
assert(pu.Internal.Overlaps==false)

sol{1}.overlaps = 1;
pu = mpt_mpsol2pu(sol);
assert(pu.Internal.Overlaps==true)

end
