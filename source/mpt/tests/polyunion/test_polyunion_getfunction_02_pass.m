function test_polyunion_getfunction_02_pass
%
% double integrator example, get by string
%

%Double_Integrator;
%problem = Opt(mpt_constructMatrices(sysStruct,probStruct));
load data_mat2opt_01
problem = Opt(M);
res=problem.solve;

U = res.xopt;

Un = U.getFunction({'primal', 'obj'});
assert(isequal(Un.listFunctions, {'obj', 'primal'})); % sorted!

end
