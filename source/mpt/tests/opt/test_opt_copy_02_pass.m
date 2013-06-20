function test_opt_copy_02_pass
%
% testing copying opt object with structure and random objects
% 

P = ExamplePoly.randHrep;
problem = Opt(P);

% assign random data as struct
problem.Data.problemA = Opt(ExamplePoly.randVrep);
problem.Data.problemB = 'nothing here';
problem.Data.T = Union;

% copy
prb = problem.copy;

% do a change in the original problem
problem.Data.problemA.qp2lcp;
problem.Data.T.add(P);

% the new object must not have the same change
if isequal(prb.Data.problemA.problem_type,'LCP')
    error('Copying returned the same "Opt" object in "Data" property.');
end

if prb.Data.T.Num>=1
    error('Copying returned the same "Union" object in "Data" property.');
end


end