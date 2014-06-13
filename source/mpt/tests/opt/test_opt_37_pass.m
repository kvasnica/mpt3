function test_opt_37_pass
%
% test on order of stored indices of lower/upper bounds after elimination
% of redundant constraints

load Matrices_dataOpt37


% construct the problem
problem = Opt(Matrices);


% verify lb/ub stored internally
if any(sort(problem.Internal.removed_rows.lower)'~=1:10)
    error('All lower bounds have been internally marked as redundant.');
end
    
if any(sort(problem.Internal.removed_rows.upper)'~=1:10)
    error('All upper bounds have been internally marked as redundant.');
end

% just to check if transformation to LCP works fine
problem.qp2lcp;


end