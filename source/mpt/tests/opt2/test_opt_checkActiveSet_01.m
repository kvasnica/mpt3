function test_opt_checkActiveSet_01

Double_Integrator
M = mpt_constructMatrices(sysStruct, probStruct);
pqp = Opt(M);
status = pqp.checkActiveSet([]);
assert(status==2); % optimal

status = pqp.checkActiveSet([3; 10]);
assert(status==0); % feasible

status = pqp.checkActiveSet([14; 18]);
assert(status==-1); % infeasible

status = pqp.checkActiveSet([17; 18]);
assert(status==-2); % rankdef

end
