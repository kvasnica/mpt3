function test_opt_checkActiveSet_02
% for QPs

Double_Integrator
M = mpt_constructMatrices(sysStruct, probStruct);
x = [1; 1];
qp = Opt('H', M.H, 'f', M.Cf, 'A', M.G, 'b', M.W+M.E*x);
assert(isequal(qp.problem_type, 'QP'));
assert(~qp.isParametric)

status = qp.checkActiveSet([]);
assert(status==0);
status = qp.checkActiveSet(3);
assert(status==0);

status = qp.checkActiveSet(5);
assert(status==-1);

status = qp.checkActiveSet(1);
assert(status==-2);

status = qp.checkActiveSet([20 18 16]);
assert(status==1);

end
