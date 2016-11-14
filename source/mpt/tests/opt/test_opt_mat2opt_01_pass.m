function test_opt_mat2opt_01_pass
% mpt2 qp problem

%Double_Integrator;
%M=mpt_constructMatrices(sysStruct,probStruct);
load data_mat2opt_01

problem=Opt(M);

if ~strcmpi(problem.problem_type,'QP')
    error('Must be QP problem here.');
end

end