function test_polyhedron_interiorPoint_12_pass
%
% too many facets
%

P = Polyhedron('H',[randn(17,5) 8*rand(17,1)])+5*rand(5,1);

[~, sol] = P.minHRep();

nf = nnz(~sol.I);

% this is ok
r1 = P.interiorPoint(1:nf);

% this must fail
[worked, msg] = run_in_caller('r2 = P.interiorPoint(1:nf+1); ');
assert(~worked);
asserterrmsg(msg,'Facet index must be less than number of inequalities');

end
