function test_opt_mat2opt_02_pass
% mpt2 lp problem

% Double_Integrator;
% probStruct.norm = Inf;
% M=mpt_constructMatrices(sysStruct,probStruct);

load data_mat2opt_02
problem=Opt(M);

if ~strcmpi(problem.problem_type,'LP')
    error('Must be LP problem here.');
end

end