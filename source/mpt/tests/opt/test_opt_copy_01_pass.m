function test_opt_copy_01_pass
%
% testing copying opt object with Polyhedron object
% 

P = ExamplePoly.randHrep;
problem = Opt(P);

% assign polyhedron to Data property
problem.Data = P;

% copy
prb = problem.copy;

% do a change in the original polyhedron
problem.Data.V;

% the new object must not have the same change
if prb.Data.hasVRep
    error('Copying returned the same object in "Data" property.');
end

end