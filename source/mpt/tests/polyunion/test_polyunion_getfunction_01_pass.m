function test_polyunion_getfunction_01_pass
%
% double integrator example, get by index
%

%Double_Integrator;
%problem = Opt(mpt_constructMatrices(sysStruct,probStruct));
load data_mat2opt_01
problem = Opt(M);
res=problem.solve;

U = res.xopt;

Un = U.getFunction('primal');
assert(isequal(Un.listFunctions, {'primal'}));

end
