function test_opt_mat2opt_03_pass
% mpt2 milp problem

opt_sincos;

% construct matrices does not convert to MILP, only to LP!!!
%probStruct.N = 3;
%M=mpt_constructMatrices(sysStruct,probStruct);

load data_mat2opt_03
problem=Opt(M);

if ~strcmpi(problem.problem_type,'LP')
    error('Must be LP problem here.');
end

end